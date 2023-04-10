{
  config,
  lib,
  ...
}: let
  inherit (config.vars.colorScheme) colors;
  cfg = config.home-manager.users.${config.vars.username};
  sway = cfg.wayland.windowManager.sway.enable;
in {
  home-manager.users.${config.vars.username} = {
    programs.i3status-rust = {
      enable = lib.mkIf sway true;
      bars = {
        bottom = {
          blocks = [
            {
              block = "cpu";
              format = " $icon $utilization ";
            }
            {
              block = "memory";
              format = " $icon $mem_used_percents.eng(w:1) ";
            }
            {
              block = "disk_space";
              path = "/";
              info_type = "available";
              alert_unit = "GB";
              interval = 20;
              warning = 20.0;
              alert = 10.0;
              format = " $icon ROOT: $available.eng(w:2) ";
            }
            {
              block = "net";
              device = "wlp4s0";
              format = " $icon DOWN: $speed_down UP: $speed_up ";
            }
            {
              block = "sound";
              # driver = "pulseaudio";
              format = " $icon $volume ";
            }
            {
              block = "battery";
              device = "BAT1";
              format = " $icon $percentage ";
            }
            {
              block = "time";
              format = " $icon $timestamp.datetime(f:'%a %d/%m %R') ";
            }
          ];
          settings = {
            theme = {
              theme = "solarized-dark";
              overrides = {
                idle_bg = "#${colors.base00}";
                idle_fg = "#${colors.base05}";
                info_bg = "#${colors.base0C}";
                info_fg = "#${colors.base00}";
                good_bg = "#${colors.base0B}";
                good_fg = "#${colors.base00}";
                warning_bg = "#${colors.base0A}";
                warning_fg = "#${colors.base00}";
                critical_bg = "#${colors.base08}";
                critical_fg = "#${colors.base00}";
                separator = "<span font='12'></span>";
              };
            };
            icons = {
              icons = "awesome6";
              overrides = {
                tux = "";
                upd = "";
                noupd = "";
              };
            };
          };
        };
      };
    };
  };
}
