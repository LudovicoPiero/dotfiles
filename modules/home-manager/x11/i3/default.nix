{pkgs, ...}: {
  xsession = {
    enable = true;
    windowManager = {
      i3 = {
        enable = true;
        config = {
          bars = [];
          fonts = {
            names = ["UbuntuMono Nerd Font" "Monospace"];
            size = 11.0;
          };
          modifier = "Mod4";
          terminal = "kitty";
          startup = [
            {
              command = "${pkgs.picom-jonaburg}/bin/picom --experimental-backends";
              always = true;
            }
            {
              command = "${pkgs.dunst}/bin/dunst";
              always = true;
            }
          ];
        };
      };
    };
  };
}
