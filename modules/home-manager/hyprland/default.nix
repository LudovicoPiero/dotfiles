{ inputs, pkgs, config, lib, ... }:

{
  home.packages = with pkgs; [
    hyprpaper # For Wallpaper
    mako # Notification
    bemenu # Menu 
    wofi
    kitty
    wl-clipboard
    brightnessctl
    playerctl
    foot
    yad
    viewnior # image viewer
    #hyprland (using flakes version)
  ];
  home.file = {
    hyprland = {
      source = ../hyprland;
      target = ".config/hypr";
      recursive = true;
    };
  };
}
