{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:
{
  wayland.windowManager.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    settings = import ./__settings.nix {
      inherit
        pkgs
        lib
        config
        inputs
        ;
    };
  };
}
