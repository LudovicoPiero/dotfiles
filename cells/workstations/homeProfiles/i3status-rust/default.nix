{ config, lib, ... }:
let
  sway = config.wayland.windowManager.sway.enable;
in
{
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
            format = " $icon $timestamp.datetime(f:'%a %Y-%m-%d | %I:%M %p') ";
          }
        ];
        settings = {
          theme.theme = "ctp-mocha";
          icons.icons = "material-nf";
        };
      };
    };
  };
}
