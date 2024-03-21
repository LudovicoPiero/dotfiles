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
          (functions "nixosProfiles")
          (functions "home")

          # Suites
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
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    impermanence.url = "github:nix-community/impermanence";
    lanzaboote.url = "github:nix-community/lanzaboote";
    nix-super.url = "github:privatevoid-net/nix-super";
  };
}
