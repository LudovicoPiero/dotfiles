{
  self,
  inputs,
  self',
  inputs',
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
        _module.args = {inherit self' inputs' inputs;};
        home-manager.extraSpecialArgs = {inherit self' inputs' inputs;};
        home-manager.users.ludovico = {
          imports = [self.homeModules.ludovico];

          home.stateVersion = "22.11";
        };
      }
    ];
  };
}
