{
  pkgs,
  config,
  lib,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    mkOption
    mkIf
    types
    ;

  cfg = config.mine.wleave;
in
{
  options.mine.wleave = {
    enable = mkEnableOption "wleave";

    package = mkOption {
      type = types.package;
      default = pkgs.wleave;
      description = "The wleave package to use.";
    };
  };

  config = mkIf cfg.enable {
    hm = {
      home.packages = [ cfg.package ];

      xdg.configFile = {
        "wleave/layout.json".text = ''
          {
              "buttons": [
                  {
                      "label": "lock",
                      "action": "swaylock",
                      "text": "Lock",
                      "keybind": "l",
                      "icon": "/home/lewdo/.config/wleave/icons/lock.svg"
                  },
                  {
                      "label": "hibernate",
                      "action": "systemctl hibernate",
                      "text": "Hibernate",
                      "keybind": "h",
                      "icon": "/home/lewdo/.config/wleave/icons/hibernate.svg"
                  },
                  {
                      "label": "logout",
                      "action": "${
                        if (config.mine.hyprland.withUWSM || config.mine.sway.withUWSM) then
                          "uwsm stop"
                        else
                          "loginctl terminate-user $USER"
                      }",
                      "text": "Logout",
                      "keybind": "e",
                      "icon": "/home/lewdo/.config/wleave/icons/logout.svg"
                  },
                  {
                      "label": "shutdown",
                      "action": "systemctl poweroff",
                      "text": "Shutdown",
                      "keybind": "s",
                      "icon": "/home/lewdo/.config/wleave/icons/shutdown.svg"
                  },
                  {
                      "label": "suspend",
                      "action": "systemctl suspend",
                      "text": "Suspend",
                      "keybind": "u",
                      "icon": "/home/lewdo/.config/wleave/icons/suspend.svg"
                  },
                  {
                      "label": "reboot",
                      "action": "systemctl reboot",
                      "text": "Reboot",
                      "keybind": "r",
                      "icon": "/home/lewdo/.config/wleave/icons/reboot.svg"
                  }
              ]
          }
        '';

        "wleave/style.css".text =
          let
            fontSize = toString (config.mine.fonts.size + 10);
          in
          ''
            window {
                background-color: rgba(12, 12, 12, 0.8);
            }

            button {
                color: oklab(from var(--view-fg-color) var(--standalone-color-oklab));
                background-color: var(--view-bg-color);
                border: none;
                padding: 10px;
            }

            button label.action-name {
                font-size: ${fontSize}px;
            }

            button label.keybind {
                font-size: ${fontSize}px;
                font-family: ${config.mine.fonts.terminal.name};
            }

            button:hover label.keybind, button:focus label.keybind {
                opacity: 1;
            }

            button:focus,
            button:hover {
                background-color: color-mix(in srgb, var(--accent-bg-color), var(--view-bg-color));
            }

            button:active {
                color: var(--accent-fg-color);
                background-color: var(--accent-bg-color);
            }

            button#shutdown {
                --view-fg-color: #ff8d8d;
            }

            button#hibernate {
                --view-fg-color: #a8c0ff;
            }

            button#reboot {
                --view-fg-color: #84ffaa;
            }

            button#lock {
                --view-fg-color: #ffe8b6;
            }

            button#logout {
                --view-fg-color: #ffcca8;
            }

            button#suspend {
                --view-fg-color: #caaff9;
            }
          '';
      };
    };
  };
}
