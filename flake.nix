{
  description = "Airi's NixOS Configuration";

  outputs =
    inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        ./hosts
        ./parts
      ];
    };

  inputs = {
    # Nixpkgs
    nixpkgs-unstable = {
      type = "github";
      owner = "NixOS";
      repo = "nixpkgs";
      ref = "nixos-unstable-small";
    };
    nixpkgs.follows = "nixpkgs-unstable";

    # Pinned version of nixpkgs for specific packages.
    nixpkgs-cage = {
      type = "github";
      owner = "NixOS";
      repo = "nixpkgs";
      ref = "5be222164c59f700ee149c6e6903c146135eb1f9";
    };

    # Core dependencies
    flake-parts = {
      type = "github";
      owner = "hercules-ci";
      repo = "flake-parts";
    };
    flake-parts.inputs.nixpkgs-lib.follows = "nixpkgs";

    home-manager = {
      type = "github";
      owner = "nix-community";
      repo = "home-manager";
    };
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # Overlays and package sets
    emacs-overlay = {
      type = "github";
      owner = "nix-community";
      repo = "emacs-overlay";
    };
    emacs-overlay.inputs.nixpkgs.follows = "nixpkgs";

    firefox-addons = {
      type = "gitlab";
      owner = "rycee";
      repo = "nur-expressions";
      dir = "pkgs/firefox-addons";
    };
    firefox-addons.inputs.nixpkgs.follows = "nixpkgs";

    ludovico-pkgs = {
      type = "github";
      owner = "LudovicoPiero";
      repo = "pkgs";
    };

    # NixOS modules and tools
    lanzaboote = {
      type = "github";
      owner = "nix-community";
      repo = "lanzaboote";
      ref = "v0.4.2";
    };
    lanzaboote.inputs.nixpkgs.follows = "nixpkgs";

    niri-flake = {
      type = "github";
      owner = "sodiboo";
      repo = "niri-flake";
    };

    programsdb = {
      type = "github";
      owner = "wamserma";
      repo = "flake-programs-sqlite";
    };
    programsdb.inputs.nixpkgs.follows = "nixpkgs";

    sops-nix = {
      type = "github";
      owner = "Mic92";
      repo = "sops-nix";
    };
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";

    wrapper-manager = {
      type = "github";
      owner = "viperML";
      repo = "wrapper-manager";
    };

    # Specific flakes
    ludovico-nixvim = {
      type = "github";
      owner = "LudovicoPiero";
      repo = "nvim-flake";
    };

    zen-browser = {
      type = "github";
      owner = "0xc000022070";
      repo = "zen-browser-flake";
    };
    zen-browser.inputs.nixpkgs.follows = "nixpkgs";

    # Theming
    nix-colors = {
      type = "github";
      owner = "misterio77";
      repo = "nix-colors";
    };
  };
}
