{
  pkgs,
  inputs,
  ...
} @ args: {
  home.packages = [
    # Utils
    inputs.hyprland-contrib.packages.${pkgs.system}.grimblast
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.default;
    settings = import ./settings.nix args;
  };
}
