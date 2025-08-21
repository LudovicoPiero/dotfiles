# =============================================================================
# NOTE: Test framework/library: pytest
# These tests validate the structure and critical invariants of flake.lock,
# with an emphasis on the updated/added inputs in this PR (zen-browser, lix/lix-module,
# nixpkgs-unstable as the primary nixpkgs, etc.). They avoid brittle pin assertions
# (timestamps/hashes) but check owners/repos/types and linkage integrity.
# =============================================================================

from __future__ import annotations

import json
import re
from pathlib import Path
from typing import Any, Dict, Tuple

import pytest


def _flake_lock_path() -> Path:
    # Expect flake.lock at the repo root
    repo_root = Path(__file__).resolve().parents[1]
    p = repo_root / "flake.lock"
    assert p.exists(), f"flake.lock not found at expected path: {p}"
    return p


@pytest.fixture(scope="session")
def flake_lock() -> Dict[str, Any]:
    p = _flake_lock_path()
    try:
        data = json.loads(p.read_text(encoding="utf-8"))
    except json.JSONDecodeError as e:
        pytest.fail(f"flake.lock is not valid JSON: {e}", pytrace=False)
    assert isinstance(data, dict), "flake.lock root must be a JSON object"
    return data


@pytest.fixture(scope="session")
def nodes(flake_lock: Dict[str, Any]) -> Dict[str, Any]:
    assert "nodes" in flake_lock and isinstance(flake_lock["nodes"], dict), "'nodes' must be present and a mapping"
    return flake_lock["nodes"]


@pytest.fixture(scope="session")
def root_node(nodes: Dict[str, Any]) -> Dict[str, Any]:
    assert "root" in nodes, "The 'root' node must exist in flake.lock nodes"
    return nodes["root"]


@pytest.fixture(scope="session")
def root_inputs(root_node: Dict[str, Any]) -> Dict[str, Any]:
    assert "inputs" in root_node and isinstance(root_node["inputs"], dict), "'root.inputs' must be present"
    return root_node["inputs"]


def test_top_level_structure(flake_lock: Dict[str, Any]) -> None:
    for key in ("nodes", "root", "version"):
        assert key in flake_lock, f"Top-level key '{key}' missing"
    assert isinstance(flake_lock["version"], int), "'version' must be an integer"
    assert flake_lock["version"] == 7, "Expected lockfile version 7 for modern Nix flakes"


def test_root_and_nodes_presence(flake_lock: Dict[str, Any], nodes: Dict[str, Any]) -> None:
    assert flake_lock["root"] == "root", "Top-level 'root' should reference the 'root' node"
    assert "root" in nodes, "'root' node must be present in 'nodes'"


def test_expected_key_nodes_exist(nodes: Dict[str, Any]) -> None:
    # Focus on nodes touched or highlighted by the PR/diff
    expected = {
        "nixpkgs-unstable",
        "nixpkgs-stable",
        "home-manager",
        "emacs-overlay",
        "firefox-addons",
        "zen-browser",
        "lix",
        "lix-module",
        "lanzaboote",
        "nixvim",
        "neovim-overlay",
        "neovim-src",
        "nui-nvim",
        "nix-colors",
        "programsdb",
        "ludovico-nixvim",
        "ludovico-pkgs",
        "flake-parts",
        "git-hooks",
        "sops-nix",
    }
    missing = sorted(expected - set(nodes.keys()))
    assert not missing, f"Expected nodes missing from lockfile: {missing}"


def test_locked_types_and_required_fields(nodes: Dict[str, Any]) -> None:
    allowed_types = {"github", "gitlab", "tarball"}
    for name, node in nodes.items():
        locked = node.get("locked")
        if not isinstance(locked, dict):
            # some nodes may be purely "original" or structural; continue
            continue
        t = locked.get("type")
        assert t in allowed_types, f"{name!r}: unexpected locked.type={t!r}"

        if t in {"github", "gitlab"}:
            for k in ("owner", "repo", "rev"):
                assert k in locked, f"{name!r}: missing '{k}' in locked for {t}"
        elif t == "tarball":
            assert "url" in locked, f"{name!r}: tarball source must provide 'url'"


def test_nar_hash_format(nodes: Dict[str, Any]) -> None:
    pat = re.compile(r"^sha256-[A-Za-z0-9+/=]+$")
    offenders: list[Tuple[str, str]] = []
    for name, node in nodes.items():
        locked = node.get("locked") or {}
        nar = locked.get("narHash")
        if nar is None:
            continue
        if not isinstance(nar, str) or not pat.match(nar):
            offenders.append((name, str(nar)))
    assert not offenders, f"Invalid narHash format for nodes: {offenders}"


def test_last_modified_plausible(nodes: Dict[str, Any]) -> None:
    # Check timestamps are reasonable (between ~2020 and ~2033)
    lower, upper = 1_600_000_000, 2_000_000_000
    bad: list[Tuple[str, Any]] = []
    for name, node in nodes.items():
        locked = node.get("locked") or {}
        ts = locked.get("lastModified")
        if ts is None:
            continue
        if not isinstance(ts, int) or not (lower <= ts <= upper):
            bad.append((name, ts))
    assert not bad, f"Unreasonable 'lastModified' values: {bad}"


@pytest.mark.parametrize(
    "node_key, expected_type, owner, repo, expected_original_ref",
    [
        ("nixpkgs-unstable", "github", "NixOS", "nixpkgs", "nixos-unstable-small"),
        ("nixpkgs-stable", "github", "NixOS", "nixpkgs", "nixos-24.11"),
        ("home-manager", "github", "nix-community", "home-manager", None),
        ("emacs-overlay", "github", "nix-community", "emacs-overlay", None),
        ("firefox-addons", "gitlab", "rycee", "nur-expressions", None),
        ("zen-browser", "github", "0xc000022070", "zen-browser-flake", None),
        ("nixvim", "github", "nix-community", "nixvim", None),
        ("neovim-overlay", "github", "nix-community", "neovim-nightly-overlay", None),
        ("neovim-src", "github", "neovim", "neovim", None),
        ("nui-nvim", "github", "MunifTanjim", "nui.nvim", None),
        ("rust-analyzer-src", "github", "rust-lang", "rust-analyzer", "nightly"),
        ("crane", "github", "ipetkov", "crane", None),
        ("lanzaboote", "github", "nix-community", "lanzaboote", None),
        ("git-hooks", "github", "cachix", "git-hooks.nix", None),
        ("sops-nix", "github", "Mic92", "sops-nix", None),
    ],
)
def test_specific_nodes_metadata(
    nodes: Dict[str, Any],
    node_key: str,
    expected_type: str,
    owner: str,
    repo: str,
    expected_original_ref: str | None,
) -> None:
    assert node_key in nodes, f"Missing expected node {node_key!r}"
    node = nodes[node_key]
    locked = node.get("locked") or {}
    assert locked.get("type") == expected_type, f"{node_key!r} type mismatch"
    if expected_type in {"github", "gitlab"}:
        assert locked.get("owner") == owner, f"{node_key!r} owner mismatch"
        assert locked.get("repo") == repo, f"{node_key!r} repo mismatch"
    if expected_original_ref is not None:
        original = node.get("original") or {}
        assert original.get("ref") == expected_original_ref, (
            f"{node_key!r} original.ref expected {expected_original_ref!r}"
        )


def test_tarball_nodes_have_urls(nodes: Dict[str, Any]) -> None:
    for key in ("lix", "lix-module"):
        assert key in nodes, f"Missing tarball node {key}"
        locked = nodes[key].get("locked") or {}
        assert locked.get("type") == "tarball", f"{key!r} should be tarball"
        url = locked.get("url")
        assert isinstance(url, str) and url.startswith("https://"), f"{key!r} tarball URL invalid: {url!r}"
        assert "git.lix.systems" in url, f"{key!r} tarball URL should come from git.lix.systems: {url!r}"
        assert "narHash" in locked, f"{key!r} tarball must include a narHash"


def test_flake_false_nodes(nodes: Dict[str, Any]) -> None:
    expected_false = {"neovim-src", "nui-nvim", "flake-compat", "flake-compat_2", "flake-compat_3"}
    for key in expected_false:
        assert key in nodes, f"Expected node {key!r} is missing"
        assert nodes[key].get("flake") is False, f"{key!r} must have 'flake': false"


def test_root_inputs_sanity_and_nixpkgs_points_to_unstable(root_inputs: Dict[str, Any]) -> None:
    # root.inputs should include a set of important keys
    subset = {
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
        "nixpkgs",
        "nixpkgs-unstable",
        "programsdb",
        "sops-nix",
        "wrapper-manager",
        "zen-browser",
    }
    missing = sorted(subset - set(root_inputs.keys()))
    assert not missing, f"root.inputs missing expected keys: {missing}"

    # Ensure 'nixpkgs' input resolves to 'nixpkgs-unstable' as per PR focus
    val = root_inputs.get("nixpkgs")
    assert val is not None, "'nixpkgs' must be present in root.inputs"
    if isinstance(val, list):
        assert "nixpkgs-unstable" in val, "root.inputs.nixpkgs should map to nixpkgs-unstable"
    else:
        assert val == "nixpkgs-unstable", "root.inputs.nixpkgs should map to nixpkgs-unstable"


def test_input_linkage_points_to_known_nodes_or_root_inputs(nodes: Dict[str, Any], root_inputs: Dict[str, Any]) -> None:
    # Each input references either a node key directly or a path whose last element
    # should be a known node or a key in root.inputs.
    node_keys = set(nodes.keys())
    root_input_keys = set(root_inputs.keys())
    errors: list[str] = []

    def refs_ok(v: Any, owner_node: str, input_name: str) -> bool:
        if isinstance(v, str):
            return v in node_keys or v in root_input_keys
        if isinstance(v, list) and v:
            last = v[-1]
            return isinstance(last, str) and (last in node_keys or last in root_input_keys)
        # other forms are unusual; flag them
        errors.append(f"{owner_node}.inputs[{input_name!r}] has unexpected value {v!r}")
        return False

    for name, node in nodes.items():
        inputs = node.get("inputs")
        if not isinstance(inputs, dict):
            continue
        for k, v in inputs.items():
            ok = refs_ok(v, name, k)
            if not ok:
                errors.append(f"{name}.inputs[{k}] -> {v!r} does not reference known nodes/root inputs")

    assert not errors, "Invalid or unresolved inputs found:\n- " + "\n- ".join(errors)