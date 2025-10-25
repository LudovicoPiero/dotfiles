{
  description = "Ludovico's dotfiles";

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

    hjem = {
      type = "github";
      owner = "feel-co";
      repo = "hjem";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ludovico-nvim = {
      type = "github";
      owner = "ludovicopiero";
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
  };

  outputs =
    inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" ];
      perSystem =
        { pkgs, system, ... }:
        {
          packages.nvim = inputs.ludovico-nvim.packages.${system}.default;
          packages.default = pkgs.hello;
        };

      flake = {
        nixosConfigurations = {
          sforza = inputs.nixpkgs.lib.nixosSystem {
            specialArgs = { inherit inputs; };
            modules = [
              ./modules
              ./hosts/sforza/configuration.nix
            ];
          };
        };
      };
    };
}
