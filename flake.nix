{
  description = "Description for the project";

  inputs = {
    # Main stuff
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    devshell.url = "github:numtide/devshell";
    treefmt-nix.url = "github:numtide/treefmt-nix";
    flake-parts.url = "github:hercules-ci/flake-parts";
    lanzaboote.url = "github:nix-community/lanzaboote";
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
    impermanence.url = "github:nix-community/impermanence";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{ nixpkgs, flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        # To import a flake module
        # 1. Add foo to inputs
        # 2. Add foo as a parameter to the outputs function
        # 3. Add here: foo.flakeModule
        inputs.devshell.flakeModule
        inputs.treefmt-nix.flakeModule

        ./hosts
        ./pkgs
      ];

      systems = [
        "x86_64-linux"
        # "aarch64-linux"
        # "aarch64-darwin"
        # "x86_64-darwin"
      ];

      perSystem =
        {
          config,
          pkgs,
          system,
          inputs',
          ...
        }:
        {
          # This sets `pkgs` to a nixpkgs with allowUnfree option set.
          _module.args.pkgs = import nixpkgs {
            inherit system;
            config.allowUnfree = true;
          };

          # configure devshell
          devShells.default =
            let
              devshell = import ./parts/devshell;
            in
            inputs'.devshell.legacyPackages.mkShell {
              inherit (devshell) env;
              name = "Devshell";
              commands = devshell.shellCommands;
              packages = [ config.treefmt.build.wrapper ];
            };

          # configure treefmt
          treefmt = {
            projectRootFile = "flake.nix";
            programs = {
              alejandra.enable = true;
              deadnix.enable = true;
              statix.enable = true;
              # statix.disabled-lints = ["repeated_keys"];
              stylua.enable = true;
            };

            settings.formatter.stylua.options = [
              "--indent-type"
              "Spaces"
              "--indent-width"
              "2"
              "--quote-style"
              "ForceDouble"
            ];
          };
        };

      flake = {
        # The usual flake attributes can be defined here, including system-
        # agnostic ones like nixosModule and system-enumerating ones, although
        # those are more easily expressed in perSystem.
      };
    };
}
