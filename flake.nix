{
  description = "xd uwu";

  outputs =
    inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        ./hosts
        ./parts
      ];
    };

  # Inputs are written in attribute-set form instead of using `url = "...";` strings.
  # This provides more structure, makes parsing easier, and is helpful for tools or flake editors.
  #
  # Conventions used:
  # - GitHub shorthand `github:owner/repo/ref` becomes:
  #     {
  #       type = "github";
  #       owner = "owner";
  #       repo = "repo";
  #       ref = "ref";  # optional, if a branch/tag/commit is specified
  #     }
  # - If no `ref` is given, the flake defaults to the repository's default branch.
  #
  # - GitLab uses the same structure with `type = "gitlab"`.
  # - For tarball archives (e.g., Lix), we use:
  #     {
  #       type = "tarball";
  #       url = "https://...";
  #     }
  # - For flakes with directory overlays (e.g., `?dir=...`), we add a `dir = "..."` field.
  # - `.inputs.nixpkgs.follows = "..."` lines are kept unchanged to simplify dependency alignment.
  # - Flakes that don’t expose a flake (like `catppuccin-base16`) explicitly set `flake = false`.

  inputs = {
    nixpkgs-unstable = {
      type = "github";
      owner = "NixOS";
      repo = "nixpkgs";
      ref = "nixos-unstable-small";
    };
    nixpkgs.follows = "nixpkgs-unstable";

    home-manager = {
      type = "github";
      owner = "nix-community";
      repo = "home-manager";
    };
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    flake-parts = {
      type = "github";
      owner = "hercules-ci";
      repo = "flake-parts";
    };
    flake-parts.inputs.nixpkgs-lib.follows = "nixpkgs";

    lanzaboote = {
      type = "github";
      owner = "nix-community";
      repo = "lanzaboote";
      ref = "v0.4.2";
    };
    lanzaboote.inputs.nixpkgs.follows = "nixpkgs";

    firefox-addons = {
      type = "gitlab";
      owner = "rycee";
      repo = "nur-expressions";
      dir = "pkgs/firefox-addons";
    };
    firefox-addons.inputs.nixpkgs.follows = "nixpkgs";

    sops-nix = {
      type = "github";
      owner = "Mic92";
      repo = "sops-nix";
    };
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";

    programsdb = {
      type = "github";
      owner = "wamserma";
      repo = "flake-programs-sqlite";
    };
    programsdb.inputs.nixpkgs.follows = "nixpkgs";

    lix-module = {
      type = "tarball";
      url = "https://git.lix.systems/lix-project/nixos-module/archive/2.93.1.tar.gz";
    };
    lix-module.inputs.nixpkgs.follows = "nixpkgs";

    ludovico-nixvim = {
      type = "github";
      owner = "LudovicoPiero";
      repo = "nvim-flake";
    };
    ludovico-nixvim.inputs.nixpkgs.follows = "nixpkgs";

    ludovico-pkgs = {
      type = "github";
      owner = "LudovicoPiero";
      repo = "pkgs";
    };
    ludovico-pkgs.inputs.nixpkgs.follows = "nixpkgs";

    zen-browser = {
      type = "github";
      owner = "0xc000022070";
      repo = "zen-browser-flake";
    };
    zen-browser.inputs.nixpkgs.follows = "nixpkgs";

    wrapper-manager = {
      type = "github";
      owner = "viperML";
      repo = "wrapper-manager";
    };

    emacs-overlay = {
      type = "github";
      owner = "nix-community";
      repo = "emacs-overlay";
    };
    emacs-overlay.inputs.nixpkgs.follows = "nixpkgs";

    nix-colors = {
      type = "github";
      owner = "misterio77";
      repo = "nix-colors";
    };
  };
}
