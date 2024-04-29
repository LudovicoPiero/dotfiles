{
  self,
  inputs,
  ...
}: {
  /*
  TODO: use flake.nixosModules
  https://github.com/srid/nixos-flake/blob/master/examples/both/flake.nix#L88
  */
  flake.nixosConfigurations.sforza = self.nixos-flake.lib.mkLinuxSystem {
    imports = [
      ./sforza
      ../modules/core
      ../modules/graphical
      ../modules/secrets

      inputs.chaotic.nixosModules.default
      inputs.hyprland.nixosModules.default
      inputs.impermanence.nixosModule
      inputs.lanzaboote.nixosModules.lanzaboote
      inputs.sops-nix.nixosModules.sops
      self.nixosModules.home-manager
      {
        _module.args = {inherit self inputs;};
        home-manager.extraSpecialArgs = {inherit self inputs;};
        home-manager.users.ludovico = {
          imports = [self.homeModules.ludovico];

          home.stateVersion = "23.11";
        };
      }
    ];
  };
}
