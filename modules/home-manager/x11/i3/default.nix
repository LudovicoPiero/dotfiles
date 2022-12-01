{
  pkgs,
  config,
  ...
}: let
  inherit (config.colorscheme) colors;
in {
  imports = [
      ../../apps/i3status
  ];

  xsession = {
    enable = true;
    scriptPath = ".xsession-hm";
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
          window.border = 1;
          window.commands = [
            {
              command = "border pixel 1";
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
            background = "#1E1E2E";
            focused = {
              #<colorclass> <border> <background> <text> <indicator> <child_border>
              background = "#1E1E2E";
              border = "#B4BEFE";
              text = "#CDD6F4";
              indicator = "#2E9EF4";
              childBorder = "#285577";
            };
            focusedInactive = {
              background = "#1E1E2E";
              border = "#6C7086";
              text = "#BAC2DE";
              childBorder = "#5f676a";
              indicator = "#484e50";
            };
            placeholder = {
              background = "#900000";
              border = "#2F343A";
              text = "#ffffff";
              childBorder = "#0c0c0c";
              indicator = "#000000";
            };
            unfocused = {
              background = "#181825";
              border = "#6C7086";
              text = "#BAC2DE";
              childBorder = "#222222";
              indicator = "#292d2e";
            };
            urgent = {
              background = "#900000";
              border = "#2F343A";
              text = "#ffffff";
              childBorder = "#900000";
              indicator = "#900000";
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
              command = "${pkgs.picom}/bin/picom --experimental-backends";
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
