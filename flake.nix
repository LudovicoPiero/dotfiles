{
  outputs = inputs @ {
    self,
    nixpkgs,
    devshell,
    treefmt-nix,
    flake-parts,
    ez-configs,
    ...
  }:
    flake-parts.lib.mkFlake {inherit inputs;} {
      imports = [
        ez-configs.flakeModule
        devshell.flakeModule
        treefmt-nix.flakeModule

        ./pkgs
      ];

      systems = ["x86_64-linux"];

      ezConfigs = let
        username = "airi";
      in {
        root = ./.;
        globalArgs = {
          inherit self inputs username;
        };
      };

      perSystem = {
        config,
        pkgs,
        system,
        inputs',
        ...
      }: {
        # This sets `pkgs` to a nixpkgs with allowUnfree option set.
        _module.args.pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };

        # configure devshell
        devShells.default = let
          devshell = import ./parts/devshell;
        in
          inputs'.devshell.legacyPackages.mkShell {
            inherit (devshell) env;
            name = "Devshell";
            commands = devshell.shellCommands;
            packages = [
              config.treefmt.build.wrapper
            ];
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

          settings.formatter.stylua.options = ["--indent-type" "Spaces" "--indent-width" "2" "--quote-style" "ForceDouble"];
        };
      };
    };

  inputs = {
    ####################
    #       Main       #
    ####################
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable-small";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    ez-configs = {
      url = "github:ehllie/ez-configs";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-parts.follows = "flake-parts";
      };
    };

    ####################
    #       Deps       #
    ####################
    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-parts.follows = "flake-parts";
    };

    hyprland = {
      url = "github:hyprwm/hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nh = {
      url = "github:viperML/nh";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    devshell = {
      url = "github:numtide/devshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-super = {
      url = "github:privatevoid-net/nix-super";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    chaotic = {
      url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-colors = {
      url = "github:misterio77/nix-colors";
    };

    nur = {
      url = "github:nix-community/nur";
    };

    impermanence = {
      url = "github:nix-community/impermanence";
    };
  };
}
