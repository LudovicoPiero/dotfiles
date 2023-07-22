{
  self,
  inputs,
  ...
}: {
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
    ];
  };
}
