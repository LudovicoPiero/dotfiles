{ inputs, pkgs, config, lib, ... }:

{
  home.packages = with pkgs; [
    hyprpaper # For Wallpaper
    mako # Notification
    bemenu # Menu 
    wofi # Menu
    waybar # Bar
    inputs.hyprland-contrib.packages.${pkgs.system}.grimblast

    # Terminal
    kitty
    foot

    # Utils
    grim
    slurp
    jq
    wl-clipboard
    brightnessctl
    playerctl
    yad
    viewnior
    xdg-user-dirs
    xdg-utils
    #hyprland (using flakes version)
  ];

  home.sessionVariables = {
    NIXOS_OZONE_WL = "1";
  };

  home.file = {
    hyprland = {
      source = ../hyprland;
      target = ".config/hypr";
      recursive = true;
    };
  };
}
