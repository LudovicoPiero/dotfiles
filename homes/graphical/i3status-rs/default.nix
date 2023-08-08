{
  config,
  lib,
  ...
}: let
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
            theme = "dracula";
            # overrides = {
            #  separator = "<span font='12'></span>";
            # };
          };
          icons = {
            icons = "material-nf";
          };
        };
      };
    };
  };
}
