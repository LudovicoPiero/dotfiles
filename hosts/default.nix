{ withSystem, inputs, ... }:
{
  flake.nixosConfigurations.sforza = withSystem "x86_64-linux" (
    { config, inputs', ... }:
    inputs.nixpkgs.lib.nixosSystem {
      specialArgs = {
        inherit (config) packages;
        inherit inputs inputs';
      };
      modules = [
        # This module could be moved into a separate file; otherwise we might
        # as well have used ctx.config.packages directly.
        (
          { ... }:
          {
            # TODO: Setup home-manager
            imports = [ ./sforza ];
            system.stateVersion = "23.11";
          }
        )
      ];
    }
  );
}
