# lib/mkHost.nix
{ withSystem, inputs }:

# Define a function that builds a nixosConfiguration for a given host
# Usage example:
# mkHost "sforza" ./sforza/configuration.nix
hostName: configPath: system:
withSystem system (
  ctx@{ inputs', ... }:
  let
    sharedModules = import ../modules;

    specialArgs = { inherit inputs inputs'; };
  in
  inputs.nixpkgs.lib.nixosSystem {
    inherit specialArgs;
    modules = [
      {
        imports = [
          sharedModules
          configPath
        ];
      }
    ];
  }
)
