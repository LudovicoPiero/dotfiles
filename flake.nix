{
  outputs =
    {
      self,
      std,
      hive,
      ...
    }@inputs:
    hive.growOn {
      inherit inputs;

      nixpkgsConfig = {
        allowUnfree = true;
      };

      cellsFrom = ./cells;
      cellBlocks =
        with hive.blockTypes;
        with std.blockTypes;
        [
          (functions "bee")

          # Profiles
          (functions "hardwareProfiles")
          (functions "homeProfiles")
          (functions "nixosProfiles")

          # Suites
          (functions "homeSuites")
          (functions "nixosSuites")

          # Configurations
          nixosConfigurations
        ];
    } { nixosConfigurations = hive.collect self "nixosConfigurations"; };

  inputs = {
    nixpkgs-stable.url = "github:nixos/nixpkgs/23.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs.follows = "nixpkgs-unstable";

    # Hive
    hive = {
      url = "github:divnix/hive";
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
    };
    std = {
      url = "github:divnix/std";
      inputs = {
        devshell.follows = "devshell";
        devshell.inputs.nixpkgs.follows = "nixpkgs";
        nixpkgs.follows = "nixpkgs";
      };
    };

    # Deps
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
    ludovico-nixpkgs.url = "github:LudovicoPiero/nixpackages";
    devshell.url = "github:numtide/devshell";
    impermanence.url = "github:nix-community/impermanence";
    lanzaboote.url = "github:nix-community/lanzaboote";
    nix-super.url = "github:privatevoid-net/nix-super";
    spicetify-nix.url = "github:gerg-l/spicetify-nix";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    base16-schemes.url = "github:LudovicoPiero/base16-schemes";
    base16-schemes.flake = false;
    nix-colors = {
      url = "github:misterio77/nix-colors";
      inputs.base16-schemes.follows = "base16-schemes";
    };
  };
}
