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
      # Setup home-manager in NixOS config

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
