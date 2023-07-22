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

      inputs.impermanence.nixosModule
      self.nixosModules.home-manager
      {
        _module.args = {inherit inputs;};
        home-manager.extraSpecialArgs = {inherit inputs;};
        home-manager.users.ludovico = {
          imports = [self.homeModules.ludovico];

          home.stateVersion = "22.11";
        };
      }
    ];
  };
}
