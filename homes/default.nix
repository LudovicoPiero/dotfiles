_: {
  flake.homeModules.ludovico = {inputs, ...}: {
    imports = [
      ./core
      ./graphical
      ./editor
      ./browser
      # ./windowManager/hyprland
      ./windowManager/sway

      inputs.nur.hmModules.nur
      inputs.nix-colors.homeManagerModules.default
      inputs.spicetify-nix.homeManagerModules.default
    ];
  };
}
