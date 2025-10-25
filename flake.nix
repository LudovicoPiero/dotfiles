{
  description = "Ludovico's dotfiles";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    flake-parts.url = "github:hercules-ci/flake-parts";

    hjem = {
      url = "github:feel-co/hjem";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ludovico-nvim.url = "github:ludovicopiero/nvim-flake";
    ludovico-nvim.inputs.nixpkgs.follows = "nixpkgs";
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
