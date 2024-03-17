{ withSystem, inputs, ... }:
let
  commonModules = ../modules;
in
{
  flake.nixosConfigurations.sforza = withSystem "x86_64-linux" (
    { config, inputs', ... }:
    inputs.nixpkgs.lib.nixosSystem {
      specialArgs = {
        inherit (config) packages;
        inherit inputs inputs';
        userName = "airi";
      };
      modules = [
        # This module could be moved into a separate file; otherwise we might
        # as well have used ctx.config.packages directly.
        inputs.home-manager.nixosModules.home-manager
        commonModules

        ./sforza
      ];
    }
  );
}
