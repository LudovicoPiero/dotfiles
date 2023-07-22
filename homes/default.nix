_: {
  flake.homeModules.ludovico = {
    inputs,
    pkgs,
    ...
  }: {
    imports = [
      ./core
      ./graphical
      ./editor
      ./hyprland
      ./browser

      inputs.nur.hmModules.nur
    ];
  };
}
