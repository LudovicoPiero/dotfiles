{pkgs,config,...}:
let
 inherit (config.colorscheme) colors;
in {
  imports = [
    ../../apps/i3status
    ../../apps/picom
  ];

  home.packages = with pkgs; [feh];

  xsession = {
    enable = true;
    scriptPath = ".xsession-i3";
    windowManager = {
      i3 = {
        enable = true;
        config = {
          assigns = {
            "1: web" = [{class = "^Firefox$";}];
            "0: extra" = [
              {
                class = "^Firefox$";
                window_role = "About";
              }
            ];
          };
          window.border = 2;
          window.commands = [
            {
              command = "border pixel 2";
              criteria = {class = "^.*";};
            }
          ];
          floating.border = 1;
          bars = [
            {
              position = "bottom";
              statusCommand = "${pkgs.i3status-rust}/bin/i3status-rs ~/.config/i3status-rust/config-bottom.toml";
            }
          ];
          colors = {
            background = "#${colors.base00}";
            focused = {
              #<colorclass> <border> <background> <text> <indicator> <child_border>
              background = "#${colors.base0D}";
              border = "#${colors.base05}";
              text = "#${colors.base00}";
              indicator = "#${colors.base0D}";
              childBorder = "#${colors.base0D}";
            };
            focusedInactive = {
              background = "#${colors.base0D}";
              border = "#${colors.base01}";
              text = "#${colors.base05}";
              childBorder = "#${colors.base01}";
              indicator = "#${colors.base03}";
            };
            placeholder = {
              background = "#${colors.base0D}";
              border = "#${colors.base00}";
              text = "#${colors.base05}";
              childBorder = "#${colors.base00}";
              indicator = "#${colors.base00}";
            };
            unfocused = {
              background = "#${colors.base00}";
              border = "#${colors.base01}";
              text = "#${colors.base05}";
              childBorder = "#${colors.base01}";
              indicator = "#${colors.base01}";
            };
            urgent = {
              background = "#${colors.base08}";
              border = "#${colors.base08}";
              text = "#${colors.base00}";
              childBorder = "#${colors.base08}";
              indicator = "#${colors.base08}";
            };
          };
          defaultWorkspace = "workspace number 1";
          focus = {
            followMouse = true;
            forceWrapping = false;
            mouseWarping = false;
            newWindow = "smart";
          };
          fonts = {
            names = ["UbuntuMono Nerd Font" "Monospace"];
            size = 11.0;
          };
          #keybindings = let
          #  modifier = config.xsession.windowManager.i3.config.modifier;
          #in {
          #  "${modifier}+Return" = "exec kitty";
          #  "${modifier}+Shift+q" = "kill";
          #  "${modifier}+Shift+c" = "reload";
          #  "${modifier}+Shift+r" = "restart";
          #  "${modifier}+d" = "exec ${pkgs.dmenu}/bin/dmenu_run";
          #};
          modifier = "Mod4";
          terminal = "kitty";
          startup = [
            {
              command = "${pkgs.feh}/bin/feh --bg-fill $HOME/Pictures/tdark.png";
              always = true;
            }
            {
              command = "${pkgs.picom}/bin/picom --experimental-backends";
            }
            {
              command = "${pkgs.dunst}/bin/dunst";
            }
          ];
        };
      };
    };
  };
}
