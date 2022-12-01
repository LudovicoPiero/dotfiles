{
  pkgs,
  lib,
  ...
}: {
  programs.i3status-rust = {
    enable = true;
    bars = {
      bottom = {
        blocks = [
            {
                block = "battery";
                format = " $icon BAT: $percentage";
                device = "BAT1";
                missing_format = "";
            }
          {
            block = "cpu";
            format = " $icon CPU: $utilization ";
          }
          {
            block = "disk_space";
            path = "/";
            info_type = "available";
            alert_unit = "GB";
            interval = 20;
            warning = 20.0;
            alert = 10.0;
            format = " $icon PORN FOLDER (DON'T LEAK): $available.eng(2) ";
          }
          {
            block = "memory";
            format = " $icon MEM: $mem_total_used_percents.eng(2) ";
            format_alt = " $icon_swap $swap_used_percents.eng(2) ";
          }
          {
              block = "sound";
          }
          {
            block = "time";
            interval = 60;
            format = "%a %d/%m %k:%M %p";
          }
        ];
        settings = {
          icons_format = "{icon}";
          theme = {
            theme = "dracula";
          };
          icons = {
            icons = "awesome";
          };
        };
      };
    };
  };
}
