{
  outputs = inputs @ {
    self,
    nixpkgs,
    treefmt-nix,
    flake-parts,
    ez-configs,
    ...
  }:
    flake-parts.lib.mkFlake {inherit inputs;} {
      imports = [
        ez-configs.flakeModule
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
        devShells.default = pkgs.mkShell {
          name = "Dooots";
          packages = [
            config.treefmt.build.wrapper
            inputs'.nix-super.packages.default
            # pkgs.nvfetcher
            (pkgs.writeShellApplication {
              name = "fmt";
              text = "treefmt";
            })
          ];

          # This will add The development shell with treefmt
          # and its underlying programs ( alejandra, deadnix, etc )
          inputsFrom = [config.treefmt.build.devShell];
        };

        # configure treefmt
        treefmt = {
          projectRootFile = "flake.nix";
          programs = {
            alejandra.enable = true;
            deadnix.enable = true;
            statix.enable = true;
            statix.disabled-lints = ["repeated_keys"];
            stylua.enable = true;
          };

          settings.formatter.alejandra.excludes = ["generated.nix"];
          settings.formatter.deadnix.excludes = ["generated.nix"];
          settings.formatter.statix.excludes = ["generated.nix"];
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

    nix-super = {
      url = "github:privatevoid-net/nix-super";
    };

    chaotic = {
      url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
    };

    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    base16-schemes.url = "github:LudovicoPiero/base16-schemes";
    base16-schemes.flake = false;
    nix-colors = {
      url = "github:misterio77/nix-colors";
      inputs.base16-schemes.follows = "base16-schemes";
    };

    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    impermanence = {
      url = "github:nix-community/impermanence";
    };

    hyprland = {
      url = "github:hyprwm/hyprland";
    };
  };
}
