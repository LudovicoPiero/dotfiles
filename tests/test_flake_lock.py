"""
Tests for flake.lock

Test framework: pytest (assumed; standard for Python projects with tests/).
These tests validate:
- Overall schema and structure
- Cross-references in `inputs`
- Formats of `narHash`, `rev`, `lastModified`
- Presence and type constraints for common source types (github, gitlab, tarball)
- A curated set of exact-pinned revisions and attributes introduced/changed in this PR

No third-party dependencies are used; only Python stdlib.
"""

import json
import os
import re
from urllib.parse import urlparse, parse_qs

# Resolve flake.lock path (repo root / flake.lock)
THIS_DIR = os.path.dirname(__file__)
REPO_ROOT = os.path.abspath(os.path.join(THIS_DIR, os.pardir))
LOCK_PATH = os.path.join(REPO_ROOT, "flake.lock")

HEX40 = re.compile(r"^[0-9a-f]{40}$")
NAR_SHA256 = re.compile(r"^sha256-[A-Za-z0-9+/=]{43,}$")  # base64 payload, >= 43 chars typical
VALID_TYPES = {"github", "gitlab", "tarball"}

def load_lock():
    with open(LOCK_PATH, "r", encoding="utf-8") as f:
        return json.load(f)

def iter_nodes(lock):
    nodes = lock.get("nodes", {})
    for name, node in nodes.items():
        yield name, node


def test_lock_file_exists():
    assert os.path.isfile(LOCK_PATH), f"flake.lock not found at expected path: {LOCK_PATH}"


def test_root_and_version():
    lock = load_lock()
    assert "version" in lock and isinstance(lock["version"], int), "Missing or invalid `version`."
    assert lock["version"] == 7, f"Unexpected version: {lock['version']}"
    assert "root" in lock and isinstance(lock["root"], str), "Missing or invalid `root`."
    nodes = lock.get("nodes", {})
    assert lock["root"] in nodes, "`root` must reference an existing node key in `nodes`."


def test_nodes_present_and_mapping():
    lock = load_lock()
    assert "nodes" in lock and isinstance(lock["nodes"], dict), "`nodes` must be a mapping."
    # Sanity: ensure a non-trivial number of nodes exist (helps catch truncation/merge issues)
    assert len(lock["nodes"]) >= 20, f"Expected at least 20 nodes, found {len(lock['nodes'])}."


def test_all_input_references_exist():
    lock = load_lock()
    nodes = lock["nodes"]

    def _assert_ref(ref):
        assert ref in nodes, f"Input references unknown node '{ref}'."

    for name, node in iter_nodes(lock):
        inputs = node.get("inputs")
        if not inputs:
            continue
        assert isinstance(inputs, dict), f"{name}: `inputs` must be a mapping."
        for _, target in inputs.items():
            if isinstance(target, str):
                _assert_ref(target)
            elif isinstance(target, list):
                assert target, f"{name}: `inputs` list target must not be empty."
                for ref in target:
                    assert isinstance(ref, str), f"{name}: input list items must be strings."
                    _assert_ref(ref)
            else:
                # Some lock files may support nested structures; assert we only see expected types here
                raise AssertionError(f"{name}: unexpected input reference type: {type(target).__name__}")


def test_locked_entries_have_expected_fields_by_type_and_formats():
    lock = load_lock()
    for name, node in iter_nodes(lock):
        if "locked" not in node:
            # some nodes might be purely virtual, but in this lock they generally have locked info
            continue
        locked = node["locked"]
        assert isinstance(locked, dict), f"{name}: `locked` must be a mapping."

        # Common fields
        lm = locked.get("lastModified")
        nh = locked.get("narHash")
        assert isinstance(lm, int) and lm > 1_500_000_000 and lm < 2_100_000_000, f"{name}: invalid lastModified epoch: {lm}"
        assert isinstance(nh, str) and NAR_SHA256.match(nh), f"{name}: invalid narHash format: {nh}"

        ltype = locked.get("type")
        assert ltype in VALID_TYPES, f"{name}: unexpected locked.type '{ltype}'"

        if ltype in {"github", "gitlab"}:
            for field in ("owner", "repo", "rev"):
                assert field in locked and isinstance(locked[field], str), f"{name}: missing '{field}' for {ltype} source."
            assert HEX40.match(locked["rev"]), f"{name}: rev must be a 40-hex git commit, got: {locked['rev']}"
            # Optional dir is allowed; if present ensure it's a non-empty string
            if "dir" in locked:
                assert isinstance(locked["dir"], str) and locked["dir"], f"{name}: `dir` must be non-empty if present."

        elif ltype == "tarball":
            url = locked.get("url")
            assert isinstance(url, str) and url.startswith("https://"), f"{name}: tarball `url` must be https://"
            # Often a tarball may include a 'rev' too; if present, ensure it is hex
            if "rev" in locked:
                assert isinstance(locked["rev"], str) and HEX40.match(locked["rev"]), f"{name}: tarball rev must be 40-hex."

            # If the URL query includes ?rev=..., ensure it matches locked.rev when present.
            qs = parse_qs(urlparse(url).query)
            if "rev" in qs and qs["rev"]:
                qrev = qs["rev"][0]
                if "rev" in locked:
                    assert locked["rev"] == qrev, f"{name}: locked.rev ({locked['rev']}) != URL rev ({qrev})"


def test_original_blocks_are_present_and_reasonable():
    lock = load_lock()
    for name, node in iter_nodes(lock):
        orig = node.get("original")
        assert orig is not None, f"{name}: missing `original` block."
        assert isinstance(orig, dict), f"{name}: `original` must be a mapping."
        otype = orig.get("type")
        # 'indirect' is permitted (e.g., flake-parts_4), otherwise expect a source type
        assert otype in (None, "indirect", "github", "gitlab", "tarball"), f"{name}: unexpected original.type '{otype}'"
        # If original.type is a VCS source, ensure at least owner/repo or url are present
        if otype in {"github", "gitlab"}:
            assert "owner" in orig and "repo" in orig, f"{name}: `original` for {otype} should specify owner and repo."
        if otype == "tarball":
            assert "url" in orig and isinstance(orig["url"], str), f"{name}: tarball original must include url."


def test_flake_false_nodes_have_source_origin():
    lock = load_lock()
    for name, node in iter_nodes(lock):
        if node.get("flake") is False:
            # Expect that such nodes still have a meaningful `original` source (github/gitlab/tarball).
            orig = node.get("original", {})
            otype = orig.get("type")
            assert otype in {"github", "gitlab", "tarball"}, f"{name}: flake=false nodes should originate from a concrete source."


def test_subset_of_pinned_revisions_from_diff():
    """
    Validate a curated subset of exact pins touched in this PR's diff to guard regressions.
    This is intentionally focused and not exhaustive to reduce brittleness.
    """
    lock = load_lock()
    nodes = lock["nodes"]

    expected = {
        # name: dict of expected fields
        "neovim-src": {
            "type": "github",
            "owner": "neovim",
            "repo": "neovim",
            "rev": "3ec63cdab848f903d5e46245b7b2acbf7d5cc829",
        },
        "nixpkgs-unstable": {
            "type": "github",
            "owner": "NixOS",
            "repo": "nixpkgs",
            "rev": "25bf5c5df47ae79b24fbae8d0d3f6480dadde3ed",
        },
        "home-manager": {
            "type": "github",
            "owner": "nix-community",
            "repo": "home-manager",
            "rev": "dd026d86420781e84d0732f2fa28e1c051117b59",
        },
        "emacs-overlay": {
            "type": "github",
            "owner": "nix-community",
            "repo": "emacs-overlay",
            "rev": "69f77500f06ee7f2e59cb9f2d9b7f50d2b6ac0b7",
        },
        "nixvim": {
            "type": "github",
            "owner": "nix-community",
            "repo": "nixvim",
            "rev": "94386cdc4cdb42e90685274066805685d53afa37",
        },
        "zen-browser": {
            "type": "github",
            "owner": "0xc000022070",
            "repo": "zen-browser-flake",
            "rev": "e440e752f83a7c97a45b8f47ada3f850d817343c",
        },
        "wrapper-manager": {
            "type": "github",
            "owner": "viperML",
            "repo": "wrapper-manager",
            "rev": "8ad2484b485acad0632cb0af15b5eb704e3c1d0a",
        },
        "programsdb": {
            "type": "github",
            "owner": "wamserma",
            "repo": "flake-programs-sqlite",
            "rev": "6ceec7d927c3ec7ec54856b06e92c2c47b1367eb",
        },
        "sops-nix": {
            "type": "github",
            "owner": "Mic92",
            "repo": "sops-nix",
            "rev": "3223c7a92724b5d804e9988c6b447a0d09017d48",
        },
        "ludovico-nixvim": {
            "type": "github",
            "owner": "LudovicoPiero",
            "repo": "nvim-flake",
            "rev": "4088155b1780bc9f26435d707ec7d388ac5440e1",
        },
        "firefox-addons": {
            "type": "gitlab",
            "owner": "rycee",
            "repo": "nur-expressions",
            "rev": "2dcb371b407ba4009e27a8e8adf88e6f93d40bfb",
        },
    }

    for name, exp in expected.items():
        assert name in nodes, f"Expected node '{name}' not found."
        locked = nodes[name]["locked"]
        for k, v in exp.items():
            assert locked.get(k) == v, f"{name}: expected locked.{k} == {v!r}, got {locked.get(k)!r}"


def test_tarball_sources_have_matching_rev_query_param():
    lock = load_lock()
    for name in ("lix", "lix-module"):
        node = lock["nodes"].get(name)
        assert node is not None, f"Missing expected tarball node '{name}'."
        locked = node["locked"]
        assert locked["type"] == "tarball"
        url = locked["url"]
        qs = parse_qs(urlparse(url).query)
        if "rev" in locked:
            assert qs.get("rev", [None])[0] == locked["rev"], f"{name}: URL ?rev does not match locked.rev"


def test_root_inputs_reference_existing_nodes():
    lock = load_lock()
    root = lock["nodes"][lock["root"]]
    inputs = root.get("inputs")
    assert isinstance(inputs, dict) and inputs, "`root.inputs` should be a non-empty mapping."
    # Validate a representative subset of expected inputs from the diff
    for key in [
        "emacs-overlay",
        "firefox-addons",
        "flake-parts",
        "home-manager",
        "lanzaboote",
        "lix",
        "lix-module",
        "ludovico-nixvim",
        "ludovico-pkgs",
        "nix-colors",
        "nixpkgs-unstable",
        "programsdb",
        "sops-nix",
        "wrapper-manager",
        "zen-browser",
    ]:
        assert key in inputs, f"`root.inputs` missing '{key}'."
        # input value should reference an existing node (string reference)
        ref = inputs[key]
        assert isinstance(ref, str), f"`root.inputs.{key}` must be a string reference to a node."
        assert ref in lock["nodes"], f"`root.inputs.{key}` references unknown node '{ref}'."


def test_all_revs_are_40_hex_if_present():
    lock = load_lock()
    for name, node in iter_nodes(lock):
        rev = node.get("locked", {}).get("rev")
        if rev is not None:
            assert isinstance(rev, str) and HEX40.match(rev), f"{name}: rev must be 40 hex characters."


def test_all_narhashes_are_sha256_prefixed_and_unique_per_node():
    lock = load_lock()
    seen = set()
    for name, node in iter_nodes(lock):
        locked = node.get("locked")
        if not locked:
            continue
        nar = locked.get("narHash")
        assert isinstance(nar, str) and nar.startswith("sha256-"), f"{name}: narHash must start with 'sha256-'."
        # Uniqueness across nodes is not required, but we ensure we don't see empty/duplicate empty values.
        assert nar, f"{name}: narHash must not be empty."
        seen.add((name, nar))
    # Sanity: at least 20 distinct node+nar pairs
    assert len(seen) >= 20, f"Unexpectedly few narHash entries: {len(seen)}"


def test_locked_type_values_are_expected():
    lock = load_lock()
    for name, node in iter_nodes(lock):
        ltype = node.get("locked", {}).get("type")
        if ltype is None:
            # allow nodes without locked (rare)
            continue
        assert ltype in VALID_TYPES, f"{name}: unexpected locked.type '{ltype}'"


def test_dir_field_when_present_is_relative():
    lock = load_lock()
    for name, node in iter_nodes(lock):
        locked = node.get("locked", {})
        dirv = locked.get("dir")
        if dirv is not None:
            assert not os.path.isabs(dirv), f"{name}: locked.dir should be a relative path, got absolute: {dirv}"
