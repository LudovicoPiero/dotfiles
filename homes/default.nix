_: {
  flake.homeModules.ludovico = {inputs, ...}: {
    imports = [
      ./core
      ./graphical
      ./editor
      ./hyprland
      ./browser

      inputs.nur.hmModules.nur
      inputs.nix-colors.homeManagerModules.default
    ];
  };
}
