{
  description = "NixOS Configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-master.url = "github:NixOS/nixpkgs";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-26.05";
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";

    firefox-addons = {
      type = "gitlab";
      owner = "rycee";
      repo = "nur-expressions";
      dir = "pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-parts = {
      type = "github";
      owner = "hercules-ci";
      repo = "flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    hjem = {
      type = "github";
      owner = "feel-co";
      repo = "hjem";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland = {
      type = "github";
      owner = "hyprwm";
      repo = "hyprland";
    };

    mangowm = {
      type = "github";
      owner = "mangowm";
      repo = "mango";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    niri = {
      type = "github";
      owner = "sodiboo";
      repo = "niri-flake";
    };

    noctalia = {
      type = "github";
      owner = "noctalia-dev";
      repo = "noctalia";
    };

    nvf = {
      type = "github";
      owner = "NotAShelf";
      repo = "nvf";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    programsdb = {
      type = "github";
      owner = "wamserma";
      repo = "flake-programs-sqlite";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    rust-overlay = {
      type = "github";
      owner = "oxalica";
      repo = "rust-overlay";
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
  };

  outputs =
    inputs@{ flake-parts, nixpkgs, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } (
      { withSystem, ... }:
      {
        systems = [
          "x86_64-linux"
          # "aarch64-linux"
        ];

        _module.args.extendedLib = nixpkgs.lib.extend (import ./lib { inherit inputs withSystem; });

        imports = [
          ./system
          ./packages
        ];
      }
    );
}
