{
  outputs =
    {
      self,
      std,
      hive,
      ...
    }@inputs:
    let
      inherit (inputs.nixpkgs-unstable) lib;
    in
    hive.growOn {
      inherit inputs;

      cellsFrom = ./cells;
      cellBlocks =
        with hive.blockTypes;
        with std.blockTypes;
        [
          (functions "bee")
          (functions "system")
          nixosConfigurations
        ];
    } { nixosConfigurations = hive.collect self "nixosConfigurations"; };

  inputs = {
    nixpkgs-stable.url = "github:nixos/nixpkgs/23.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs.follows = "nixpkgs-unstable";

    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
    lanzaboote.url = "github:nix-community/lanzaboote";
    impermanence.url = "github:nix-community/impermanence";
    nix-super.url = "github:privatevoid-net/nix-super";

    colmena.url = "github:zhaofengli/colmena";
    devshell.url = "github:numtide/devshell";
    arion = {
      url = "github:hercules-ci/arion";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixago = {
      url = "github:nix-community/nixago";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    std = {
      url = "github:divnix/std";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        arion.follows = "arion";
        devshell.follows = "devshell";
        devshell.inputs.nixpkgs.follows = "nixpkgs";
        nixago.follows = "nixago";
      };
    };

    hive = {
      url = "github:divnix/hive";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        colmena.follows = "colmena";
      };
    };
  };
}
