{
  description = "Ludovico's dotfiles powered by Nix Flakes + Hive";

  inputs = {
    nixpkgs-stable.url = "github:nixos/nixpkgs/23.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-master.url = "github:nixos/nixpkgs";
    nixpkgs.follows = "nixpkgs-unstable";

    impermanence.url = "github:nix-community/impermanence";
    ludovico-nixpkgs.url = "github:LudovicoPiero/nixpackages";
    ludovico-nixvim.url = "github:LudovicoPiero/nvim-flake";

    # Hive
    devshell = {
      url = "github:numtide/devshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
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

    chaotic-nyx = {
      url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
    };

    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-super = {
      url = "github:privatevoid-net/nix-super";
    };

    spicetify-nix = {
      url = "github:gerg-l/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    emacs-overlay = {
      url = "github:nix-community/emacs-overlay";
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

    swayfx = {
      url = "github:WillPower3309/swayfx";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Hyprland
    hyprland = {
      url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.xdph.follows = "xdph";
    };

    xdph = {
      url = "github:hyprwm/xdg-desktop-portal-hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Nixvim
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # For command-not-found
    programsdb = {
      url = "github:wamserma/flake-programs-sqlite";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Secrets
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.nixpkgs-stable.follows = "nixpkgs-stable";
    };
  };

  outputs =
    {
      self,
      std,
      hive,
      ...
    }@inputs:
    let
      myCollect = hive.collect // {
        renamer = _cell: target: "${target}";
      };
    in
    hive.growOn
      {
        inherit inputs;

        nixpkgsConfig = {
          allowUnfree = true;
          allowBroken = true; # For ZFS Kernel
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

            # devShells
            (nixago "configs")
            (devshells "devshells")

            # Secrets
            (functions "secrets")

            # Configurations
            nixosConfigurations
          ];
      }
      { nixosConfigurations = myCollect self "nixosConfigurations"; }
      {
        devShells = std.harvest self [
          "repo"
          "devshells"
        ];
      };
}
