{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) getExe mkIf;
  cfgmine = config.mine;
in
mkIf cfgmine.mangowc.enable {
  hj.xdg.config.files."mango/autostart.sh" = {
    executable = true;
    text = ''
      # UWSM finalize for proper session management
      uwsm finalize SWAYSOCK I3SOCK XCURSOR_SIZE XCURSOR_THEME WAYLAND_DISPLAY XDG_CURRENT_DESKTOP

      # Startup Applications
      ${getExe pkgs.brightnessctl} set 10%
      uwsm app -- ${getExe pkgs.thunderbird}
      uwsm app -- ${getExe pkgs.waybar}
      uwsm app -- ${getExe pkgs.mako}

      # Desktop portal (for obs and screen sharing)
      systemctl --user stop xdg-desktop-portal-hyprland.service
      systemctl status --user xdg-desktop-portal.service xdg-desktop-portal-gtk.service xdg-desktop-portal-wlr.service
      dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=wlroots
      systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP
    '';
  };
}
