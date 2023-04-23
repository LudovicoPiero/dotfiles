{
  config,
  nixpkgs,
  home,
  overlays,
  inputs,
}: let
  system = "x86_64-linux";
in
  home.lib.homeManagerConfiguration {
    modules = [
      {
        nixpkgs = {inherit config overlays;};

        home = rec {
          username = "ludovico";
          homeDirectory = "/home/${username}";
          /*
          NOTE: Do not change this
          unless you know what you're doing
          */
          stateVersion = "21.11";
        };

	programs.home-manager.enable = true;
      }

      inputs.hyprland.homeManagerModules.default

      ./home.nix
    ];

    # Default nixpkgs for home.nix
    pkgs = nixpkgs.outputs.legacyPackages.${system};

    # Extra arguments passed to home.nix
    extraSpecialArgs = {inherit inputs system;};
  }
