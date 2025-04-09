{ inputs, ... }:
{
  flake.nixosConfigurations =
    let
      inherit (inputs.nixpkgs.lib) nixosSystem;

      sharedModules = import ../modules;

      specialArgs = { inherit inputs; };
    in
    {
      sforza = nixosSystem {
        inherit specialArgs;
        modules = [
          sharedModules
          inputs.home-manager.nixosModules.home-manager

          ./sforza/configuration.nix
          {
            myOptions = {
              dnscrypt2.enable = false;
              teavpn2.enable = false;

              # DE / Compositor
              hyprland = {
                enable = true;
                withLTO = true;
              };
              gnome.enable = true;

              # Shell
              # Choose one of the following:
              fish.enable = true;
              zsh.enable = false;
            };

            vars = {
              # List of available color schemes:
              # https://github.com/tinted-theming/schemes/blob/spec-0.11/base16/
              colorScheme = "catppuccin-mocha";

              withGui = true; # Enable hyprland & all gui stuff
              isALaptop = true; # Enable TLP
              email = "lewdovico@gnuweeb.org";
            };
          }
        ];
      };
    };
}
