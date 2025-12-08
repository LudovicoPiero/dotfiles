{
  description = "Ludovico's dotfiles";

  outputs =
    inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        ./parts
        ./hosts
        ./packages
      ];
    };

  inputs = {
    nixpkgs-unstable = {
      type = "github";
      owner = "NixOS";
      repo = "nixpkgs";
      ref = "nixos-unstable";
    };
    nixpkgs.follows = "nixpkgs-unstable";

    # Pinned version of nixpkgs for cage
    nixpkgs-cage = {
      type = "github";
      owner = "NixOS";
      repo = "nixpkgs";
      ref = "5be222164c59f700ee149c6e6903c146135eb1f9";
    };

    flake-parts = {
      type = "github";
      owner = "hercules-ci";
      repo = "flake-parts";
    };

    chaotic = {
      type = "github";
      owner = "chaotic-cx";
      repo = "nyx";
      ref = "nyxpkgs-unstable";
    };

    hjem = {
      type = "github";
      owner = "feel-co";
      repo = "hjem";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # LIX
    lix = {
      type = "tarball";
      url = "https://git.lix.systems/lix-project/lix/archive/main.tar.gz";
      flake = false;
    };
    lix-module = {
      type = "tarball";
      url = "https://git.lix.systems/lix-project/nixos-module/archive/main.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.lix.follows = "lix";
    };

    programsdb = {
      type = "github";
      owner = "wamserma";
      repo = "flake-programs-sqlite";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      type = "github";
      owner = "Mic92";
      repo = "sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser = {
      type = "github";
      owner = "0xc000022070";
      repo = "zen-browser-flake";
    };

    rust-overlay = {
      type = "github";
      owner = "oxalica";
      repo = "rust-overlay";
      rev = "59c45eb69d9222a4362673141e00ff77842cd219"; # 2025-10-31
    };

    firefox-addons = {
      type = "gitlab";
      owner = "rycee";
      repo = "nur-expressions";
      dir = "pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nvim-flake = {
      type = "github";
      owner = "LudovicoPiero";
      repo = "nvim-flake";
    };

    # Mangowc Wayland Compositor
    mangowc = {
      type = "github";
      owner = "DreamMaoMao";
      repo = "mangowc";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-parts.follows = "flake-parts";
    };

    # Overlays and package sets
    emacs-overlay = {
      type = "github";
      owner = "nix-community";
      repo = "emacs-overlay";
      rev = "4c69fe4d8b665d3f77f2574e8b3fa1b07e9cc841"; # Hopefully fixes download errors
    };
  };
}
