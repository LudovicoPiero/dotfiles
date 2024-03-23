{
  pkgs,
  lib,
  config,
  inputs,
  ...
}: {
  wayland.windowManager.hyprland = {
    enable = true;
    package = pkgs.hyprland;
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
