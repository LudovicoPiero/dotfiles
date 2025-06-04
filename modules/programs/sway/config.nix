{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf getExe optionals;

  cfg = config.mine.sway;

  uwsm = config.programs.uwsm.package;
in
{
  hm =
    { osConfig, ... }:
    {
      wayland.windowManager.sway.config = {
        modifier = "Mod4";
        terminal = "${osConfig.vars.terminal}";
        menu = "${getExe pkgs.fuzzel}";
        startup =
          [
            (mkIf cfg.withUWSM { command = "${uwsm} finalize"; })
            { command = "${getExe pkgs.thunderbird}"; }
            { command = "${getExe pkgs.brightnessctl} set 10%"; }
          ]
          ++ optionals config.services.desktopManager.gnome.enable [
            "systemctl --user stop xdg-desktop-portal-gnome.service"
          ]
          ++ optionals config.services.desktopManager.plasma6.enable [
            "systemctl --user stop xdg-desktop-portal-kde.service"
            "systemctl --user stop plasma-xdg-desktop-portal-kde.service"
          ];

        output = {
          "eDP-1" = {
            disable = "";
          };
          "HDMI-A-1" = {
            mode = "1920x1080@180Hz";
            scale = "1";
            adaptive_sync = "on";
          };
        };

        input = {
          "type:touchpad" = {
            dwt = "enabled";
            tap = "enabled";
            natural_scroll = "enabled";
          };
          "type:keyboard" = {
            xkb_options = "ctrl:nocaps";
            repeat_delay = "300";
            repeat_rate = "30";
          };
        };
        floating = {
          border = 2;
          titlebar = true;
          criteria = [
            { window_role = "pop-up"; }
            { window_role = "bubble"; }
            { window_role = "dialog"; }
            { window_type = "dialog"; }
            { app_id = "lutris"; }
            { app_id = "thunar"; }
            { app_id = "pavucontrol"; }
            { class = ".*.exe"; } # Wine apps
            { class = "steam_app.*"; } # Steam games
            { class = "^Steam$"; } # Steam itself
          ];
        };
        gaps = {
          inner = 0;
          outer = 0;
        };
        fonts = {
          names = [ "${osConfig.mine.fonts.terminal.name}" ];
          size = 10.0;
        };
      };
    };
}
