{
  description = "Ludovico's dotfiles powered by Nix Flakes + Hive";

  outputs =
    {
      self,
      std,
      hive,
      ...
    }@inputs:
    let
      myCollect = hive.collect // {
        renamer = cell: target: "${target}";
      };
    in
    hive.growOn
      {
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

            # Secrets
            (functions "secrets")

            # Devshells
            (nixago "configs")
            (devshells "shells")

            # Configurations
            nixosConfigurations
          ];
      }
      {
        nixosConfigurations = myCollect self "nixosConfigurations";
        devShells = std.harvest self [
          "repo"
          "devshells"
        ];
      };

  inputs = {
    nixpkgs-stable.url = "github:nixos/nixpkgs/23.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable-small";
    nixpkgs-master.url = "github:nixos/nixpkgs";
    nixpkgs.follows = "nixpkgs-unstable";

    # Hive
    nixago = {
      url = "github:nix-community/nixago";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hive = {
      url = "github:divnix/hive";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    std = {
      url = "github:divnix/std";
      inputs = {
        devshell.follows = "devshell";
        nixago.follows = "nixago";
        nixpkgs.follows = "nixpkgs";
      };
    };

    ludovico-nixpkgs = {
      url = "github:LudovicoPiero/nixpackages";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    impermanence = {
      url = "github:nix-community/impermanence";
    };

    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-super = {
      url = "github:privatevoid-net/nix-super?rev=afffb6659d3672e166f3d541f0656144e1cbbb27";
    };

    spicetify-nix = {
      url = "github:gerg-l/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    emacs-overlay = {
      url = "github:nix-community/emacs-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    wrapper-manager = {
      url = "github:viperML/wrapper-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    devshell = {
      url = "github:numtide/devshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

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

    nixfmt = {
      url = "github:nixos/nixfmt";
    };
  };

  # Hyprland
  inputs = {
    hyprland = {
      url = "github:hyprwm/hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.xdph.follows = "xdph";
    };

    xdph = {
      url = "github:hyprwm/xdg-desktop-portal-hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  # Secrets
  inputs.sops-nix = {
    url = "github:Mic92/sops-nix";
    inputs.nixpkgs.follows = "nixpkgs";
    inputs.nixpkgs-stable.follows = "nixpkgs-stable";
  };
}
