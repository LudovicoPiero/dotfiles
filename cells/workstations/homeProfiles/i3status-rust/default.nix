{
  config,
  lib,
  ...
}: let
  inherit (config.colorScheme) palette;
  sway = config.wayland.windowManager.sway.enable;
in {
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
            path = "/home";
            info_type = "available";
            alert_unit = "GB";
            interval = 20;
            warning = 20.0;
            alert = 10.0;
            format = " $icon Porn Folder: $available ";
            format_alt = " $icon $available / $total ";
          }
          {
            block = "disk_space";
            path = "/home/airi/Media";
            info_type = "available";
            alert_unit = "GB";
            interval = 20;
            warning = 20.0;
            alert = 10.0;
            format = " $icon Hentai Folder: $available ";
            format_alt = " $icon $available / $total ";
          }
          {
            block = "net";
            format = " $icon ^icon_net_down $speed_down.eng(prefix:K) ^icon_net_up $speed_up.eng(prefix:K) ";
          }
          {
            block = "sound";
            format = " $icon $volume ";
          }
          {
            block = "battery";
            device = "BAT1";
            format = " $icon $percentage ";
          }
          {
            block = "time";
            format = " $icon $timestamp.datetime(f:'%a %d %b %Y | %I:%M %p') ";
          }
        ];
        settings = {
          theme = {
            theme = "ctp-mocha";
            overrides = {
              idle_bg = "#${palette.base00}";
              idle_fg = "#${palette.base05}";
              info_bg = "#${palette.base0C}";
              info_fg = "#${palette.base00}";
              good_bg = "#${palette.base0B}";
              good_fg = "#${palette.base00}";
              warning_bg = "#${palette.base0A}";
              warning_fg = "#${palette.base00}";
              critical_bg = "#${palette.base08}";
              critical_fg = "#${palette.base00}";
              separator = "<span font='12'></span>";
            };
          };
          icons = {
            icons = "material-nf";
          };
        };
      };
    };
  };
}
