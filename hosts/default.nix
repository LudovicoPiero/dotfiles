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
        ];
      };
    };
}
