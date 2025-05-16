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

          ./sforza/configuration.nix
        ];
      };

      allOptions = nixosSystem {
        inherit specialArgs;
        modules = [
          sharedModules

          ./allOptions/configuration.nix
        ];
      };
    };
}
