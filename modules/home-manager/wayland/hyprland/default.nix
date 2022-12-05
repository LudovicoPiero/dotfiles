{
  inputs,
  pkgs,
  lib,
  config,
  ...
}: {
  home.packages = with pkgs; [
    hyprpaper # For Wallpaper
    bemenu # Menu
    inputs.hyprland-contrib.packages.${pkgs.system}.grimblast

    # Utils
    brightnessctl
    grim
    jq
    playerctl
    slurp

    swaylock
    viewnior
    wl-clipboard
    xdg-user-dirs
    xdg-utils
    yad
  ];

  imports = [
    # ../apps/mako
    # ../apps/eww
    ../../apps/waybar
    ./config.nix
  ];

  home.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    MOZ_ENABLE_WAYLAND = "1";
  };

  wayland.windowManager.hyprland = {
    enable = true;
  };

  xdg.configFile = {
    "hypr/Wallpaper" = {
      source = ./Wallpaper;
    };
    "hypr/scripts" = {
      source = ./scripts;
    };
    "hypr/hyprpaper.conf" = {
      text = ''
        preload = /home/ludovico/.config/hypr/Wallpaper/Wallpaper3.jpg
        wallpaper = eDP-1,/home/ludovico/.config/hypr/Wallpaper/Wallpaper3.jpg
        ipc = off
      '';
    };
  };
}
