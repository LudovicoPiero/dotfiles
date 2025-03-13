{
  inputs,
  self,
  ...
}:
{
  flake.nixosConfigurations =
    let
      inherit (inputs.nixpkgs.lib) nixosSystem;

      sharedModules = import ../modules;

      pkgs-stable = import inputs.nixpkgs-stable {
        system = "x86_64-linux";
      };

      specialArgs = {
        inherit inputs pkgs-stable self;
      };
    in
    {
      sforza = nixosSystem {
        inherit specialArgs;
        modules = [
          sharedModules
          inputs.chaotic.nixosModules.default
          inputs.home-manager.nixosModules.home-manager

          ./sforza/configuration.nix
          {
            myOptions = {
              dnscrypt2.enable = true;
              teavpn2.enable = false;
              spotify.enable = true;
              fish.enable = true;
              vars = {
                colorScheme = "catppuccin-mocha";
                withGui = true; # Enable hyprland & all gui stuff
                isALaptop = true; # Enable TLP
                email = "lewdovico@gnuweeb.org";
              };
            };
          }
        ];
      };
    };
}
