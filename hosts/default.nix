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

      specialArgs = {
        inherit inputs self;
      };
    in
    {
      sforza = nixosSystem {
        inherit specialArgs;
        modules = [
          sharedModules

          ./sforza/configuration.nix

          inputs.chaotic.nixosModules.default
          inputs.home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            # home-manager.users.jdoe = import ./home.nix;

            # Optionally, use home-manager.extraSpecialArgs to pass
            # arguments to home.nix
          }
        ];
      };
    };
}
