{ config }:
{
  programs.i3status = {
    enable = config.wayland.windowManager.sway.enable;
    enableDefault = false;
    general = {
      colors = true;
      interval = 5;
    };

    modules = {
      "volume master" = {
        position = 1;
        settings = {
          format = "Vol: %volume ";
          format_muted = "Vol: muted (%volume) ";
        };
      };
      "disk /home" = {
        position = 2;
        settings = {
          format = "Porn Folder: %avail ";
        };
      };
      "disk /home/airi/Media" = {
        position = 3;
        settings = {
          format = "Hentai Folder: %avail ";
        };
      };
      "path_exists Wireguard" = {
        position = 4;
        settings = {
          format = "%title: %status ";
          format_down = "";
          path = "/proc/sys/net/ipv4/conf/wg0";
        };
      };
      "path_exists Teavpn2" = {
        position = 4;
        settings = {
          format = "%title: %status ";
          format_down = "";
          path = "/proc/sys/net/ipv4/conf/teavpn2-cl-01";
        };
      };
      "ethernet _first_" = {
        position = 4;
        settings = {
          format_up = "Leaked IP: %ip ";
          format_down = "E: down ";
        };
      };
      "wireless _first_" = {
        position = 5;
        settings = {
          format_up = "Leaked IP: %ip ";
          format_down = "W: down ";
        };
      };
      "battery all" = {
        position = 6;
        settings.format = "%status %percentage %remaining ";
      };
      "tztime local" = {
        position = 7;
        settings.format = "%a %d %Y %I:%M %p";
      };
    };
  };
}
