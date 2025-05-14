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
          inputs.chaotic.nixosModules.default

          ./sforza/configuration.nix
        ];
      };
    };
}
