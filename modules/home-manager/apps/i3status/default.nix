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
            block = "cpu";
          }
          {
            block = "disk_space";
            path = "/";
            info_type = "available";
            alert_unit = "GB";
            interval = 20;
            warning = 20.0;
            alert = 10.0;
            format = " $icon PORN FOLDER: $available.eng(2) ";
          }
          {
            block = "memory";
            format = " $icon $mem_total_used_percents.eng(2) ";
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
            icons = "material";
          };
        };
      };
    };
  };
}
