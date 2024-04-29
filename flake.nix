{
  outputs = inputs @ {nixpkgs, ...}:
    inputs.flake-parts.lib.mkFlake {inherit inputs;} {
      systems = [
        "aarch64-darwin"
        "aarch64-linux"
        "x86_64-linux"
      ];

      imports = [
        ./hosts
        ./homes
        ./pkgs

        inputs.devshell.flakeModule
        inputs.nixos-flake.flakeModule
        inputs.treefmt-nix.flakeModule
      ];

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
              inputs'.sops-nix.packages.default
              config.treefmt.build.wrapper
              pkgs.sops
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
    # Main Thing
    master.url = "github:nixos/nixpkgs/master";
    unstable.url = "github:nixos/nixpkgs/nixos-unstable-small";
    nixpkgs.follows = "unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland = {
      url = "github:hyprwm/hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland-contrib = {
      url = "github:hyprwm/contrib";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nh = {
      url = "github:viperML/nh";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    base16-schemes.url = "github:tinted-theming/base16-schemes";
    base16-schemes.flake = false;
    nix-colors = {
      url = "github:misterio77/nix-colors";
      inputs.base16-schemes.follows = "base16-schemes";
    };

    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
    devshell.url = "github:numtide/devshell";
    flake-parts.url = "github:hercules-ci/flake-parts";
    impermanence.url = "github:nix-community/impermanence";
    nur.url = "github:nix-community/nur";
    nix-super.url = "github:privatevoid-net/nix-super";
    nixos-flake.url = "github:srid/nixos-flake";
    treefmt-nix.url = "github:numtide/treefmt-nix";
  };
}
