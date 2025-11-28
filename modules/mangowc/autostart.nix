{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.mine.mangowc;
  cfgmine = config.mine;
  inherit (lib) getExe mkIf;

  # fetchurl for wallpaper and use swaybg to set it
  wallpaper = pkgs.fetchurl {
    # https://github.com/zhichaoh/catppuccin-wallpapers/
    url = "https://raw.githubusercontent.com/zhichaoh/catppuccin-wallpapers/refs/heads/main/os/gentoo-black-4k.png";
    hash = "sha256-7pmoLgaZR8XgnTd1JqkVDulfMHY6B2IJ74Hc8gLrDgM=";
  };
in
mkIf cfgmine.mangowc.enable {
  hj = {
    packages = [ cfg.package ];
    xdg.config.files."mango/autostart.sh" = {
      executable = true;
      text = ''
        #!/usr/bin/env sh

        # Finalize uwsm session to signal compositor is ready
        uwsm finalize SWAYSOCK I3SOCK XCURSOR_SIZE XCURSOR_THEME WAYLAND_DISPLAY XDG_CURRENT_DESKTOP

        # Update DBus and Systemd environment before restarting portals
        dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=wlroots
        systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP

        # Stop the Hyprland-specific portal ( incase config.hyprland.enable is true )
        systemctl --user stop xdg-desktop-portal-hyprland.service
        # Restart portals
        systemctl restart --user xdg-desktop-portal.service xdg-desktop-portal-gtk.service xdg-desktop-portal-wlr.service

        # Set brightness
        ${getExe pkgs.brightnessctl} set 10% &

        # Set wallpaper
        ${getExe pkgs.swaybg} -i ${wallpaper} &

        # Launch apps via uwsm
        uwsm app -- ${getExe pkgs.thunderbird} &
        uwsm app -- ${getExe pkgs.waybar} &
        uwsm app -- ${getExe pkgs.mako} &
      '';
    };
  };
}
