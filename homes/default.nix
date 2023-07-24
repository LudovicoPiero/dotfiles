_: {
  flake.homeModules.ludovico = {inputs, ...}: {
    imports = [
      ./core
      ./graphical
      ./editor
      ./browser
      ./windowManager/hyprland

      inputs.nur.hmModules.nur
      inputs.nix-colors.homeManagerModules.default
      inputs.spicetify-nix.homeManagerModule
    ];
  };
}
