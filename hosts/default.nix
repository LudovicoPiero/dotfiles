{ inputs, ... }:
{
  flake.nixosConfigurations =
    let
      inherit (inputs.nixpkgs.lib) nixosSystem;

      sharedModules = import ../modules;

      #TODO:
      colorScheme = inputs.nix-colors.lib.schemeFromYAML "catppuccin-mocha" (
        builtins.readFile (inputs.catppuccin-base16 + "/base16/mocha.yaml")
      );

      specialArgs = {
        inherit (colorScheme) palette;
        inherit inputs;
      };
    in
    {
      sforza = nixosSystem {
        inherit specialArgs;
        modules = [
          sharedModules
          inputs.chaotic.nixosModules.default

          ./sforza/configuration.nix
          {
            myOptions = {
              dnscrypt2.enable = true;

              # DE / Compositor
              hyprland = {
                enable = true;
                withLTO = true;
              };
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
