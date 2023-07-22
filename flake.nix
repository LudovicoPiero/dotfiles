{
  inputs = {
    # Principle inputs (updated by `nix run .#update`)
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    impermanence.url = "github:nix-community/impermanence";

    flake-parts.url = "github:hercules-ci/flake-parts";
    nixos-flake.url = "github:srid/nixos-flake";
  };

  outputs = inputs @ {self, ...}:
    inputs.flake-parts.lib.mkFlake {inherit inputs;} {
      systems = ["x86_64-linux"];
      imports = [inputs.nixos-flake.flakeModule];

      flake = let
        myUserName = "ludovico";
      in {
        nixosConfigurations.sforza = self.nixos-flake.lib.mkLinuxSystem {
          imports = [
            ./hosts/sforza
            ./modules/core
            # Setup home-manager in NixOS config

            inputs.impermanence.nixosModule
            self.nixosModules.home-manager
            {
              home-manager.users.${myUserName} = {
                imports = [self.homeModules.default];

                home.stateVersion = "22.11";
              };
            }
          ];
        };

        homeModules.default = {pkgs, ...}: {
          imports = [
            ./homes/core
            ./homes/graphical
          ];
          programs.starship.enable = true;
        };
      };
    };
}
