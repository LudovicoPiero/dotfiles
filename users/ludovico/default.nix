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
      }

      # Import modules from inputs
      inputs.hyprland.homeManagerModules.default
      inputs.nix-colors.homeManagerModules.default
      inputs.nur.hmModules.nur
      inputs.spicetify.homeManagerModule

      ./home.nix
    ];

    # Default nixpkgs for home.nix
    pkgs = nixpkgs.outputs.legacyPackages.${system};

    # Extra arguments passed to home.nix
    extraSpecialArgs = {inherit inputs system;};
  }
