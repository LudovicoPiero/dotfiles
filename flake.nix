{
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
    };

    hyprland = {
      url = "github:hyprwm/hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nh = {
      url = "github:viperML/nh";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    pre-commit-hooks-nix = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-super.url = "github:privatevoid-net/nix-super";
    nix-colors.url = "github:misterio77/nix-colors";
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
    nur.url = "github:nix-community/nur";
    impermanence.url = "github:nix-community/impermanence";
  };

  outputs =
    inputs@{ self, nixpkgs, pre-commit-hooks-nix, flake-parts, ez-configs, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        ez-configs.flakeModule
        pre-commit-hooks-nix.flakeModule

        ./pkgs
      ];

      systems = [ "x86_64-linux" ];

      ezConfigs =
        let
          username = "airi";
        in
        {
          root = ./.;
          globalArgs = {
            inherit self inputs username;
          };
        };

      perSystem =
        { config
        , pkgs
        , system
        , ...
        }: {
          # This sets `pkgs` to a nixpkgs with allowUnfree option set.
          _module.args.pkgs = import nixpkgs {
            inherit system;
            config.allowUnfree = true;
          };

          pre-commit.settings.hooks = {
            nixpkgs-fmt.enable = true;
            deadnix.enable = true;
            statix.enable = true;
            stylua.enable = true;
          };

          devShells.default = pkgs.mkShell {
            name = "doots";
            packages = with pkgs;[
              git
              nixpkgs-fmt
            ];
            shellHook = ''
              ${config.pre-commit.installationScript}
            '';
          };

          formatter = pkgs.nixpkgs-fmt;
        };
    };
}
