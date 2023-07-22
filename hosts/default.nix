{
  self,
  inputs,
  ...
}: {
  flake.nixosConfigurations.sforza = self.nixos-flake.lib.mkLinuxSystem {
    imports = [
      ./sforza
      ../modules/core
      ../modules/graphical

      {_module.args = {inherit inputs;};}

      inputs.impermanence.nixosModule
      self.nixosModules.home-manager
      {
        home-manager.users.ludovico = {
          imports = [self.homeModules.ludovico];

          home.stateVersion = "22.11";
        };
      }
    ];
  };
}
