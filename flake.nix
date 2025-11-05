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

    ludovico-nvim = {
      type = "github";
      owner = "LudovicoPiero";
      repo = "nvim-flake";
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
    };
    lix-module.inputs.nixpkgs.follows = "nixpkgs";
    lix-module.inputs.lix.follows = "lix";

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
    };
    firefox-addons.inputs.nixpkgs.follows = "nixpkgs";
  };
}
