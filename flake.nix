{
  description = "NixOS Configuration";

  outputs =
    { nixpkgs, ... }@inputs:
    {
      nixosConfigurations.kofun = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          ./system/kofun/configuration.nix
          ./modules
        ];
      };
    };

  inputs = {
    nixpkgs-unstable = {
      type = "github";
      owner = "NixOS";
      repo = "nixpkgs";
      ref = "nixos-unstable";
    };
    nixpkgs.follows = "nixpkgs-unstable";

    nvim-flake = {
      type = "github";
      owner = "LudovicoPiero";
      repo = "nvim-flake";
    };

    # Hjem for managing user configuration
    hjem = {
      type = "github";
      owner = "feel-co";
      repo = "hjem";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Hypr
    hyprland = {
      type = "github";
      owner = "hyprwm";
      repo = "hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Bloat
    programsdb = {
      type = "github";
      owner = "wamserma";
      repo = "flake-programs-sqlite";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    firefox-addons = {
      type = "gitlab";
      owner = "rycee";
      repo = "nur-expressions";
      dir = "pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}
