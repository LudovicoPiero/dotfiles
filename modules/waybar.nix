{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    getExe
    mkOption
    types
    mkIf
    ;

  cfg = config.mine.waybar;
  c = config.mine.theme.colors;

  modulesLeft =
    {
      hyprland = [ "hyprland/workspaces" ];
      niri = [
        "niri/workspaces"
        "niri/window"
      ];
      mangowm = [ "ext/workspaces" ];
    }
    .${cfg.wm};

  wmModuleSnippet =
    {
      hyprland = ''
        "hyprland/workspaces": {
          "format": "{icon}",
          "format-icons": {
            "main": "1 main",
            "zen": "2 zen",
            "browser": "3 browser",
            "chat": "4 chat",
            "mail": "5 mail",
            "default": "{name}"
          },
          "persistent-workspaces": {
            "*": 5
          }
        },
      '';

      niri = ''
        "niri/workspaces": {
          "format": "{icon}",
          "format-icons": {
            "main": "1 main",
            "zen": "2 zen",
            "browser": "3 browser",
            "chat": "4 chat",
            "mail": "5 mail",
            "default": "{name}"
          }
        },
        "niri/window": {
          "format": " [{title}]",
          "max-length": 40,
          "rewrite": {
            "(.*) - Mozilla Firefox": "Firefox",
            "(.*) - Discord": "Discord"
          }
        },
      '';

      mangowm = ''
        "ext/workspaces": {
          "format": "{name}",
          "on-click": "activate",
          "on-click-right": "deactivate",
          "ignore-hidden": true
        },
      '';
    }
    .${cfg.wm};
in
{
  options.mine.waybar = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable Waybar configuration.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.waybar;
      description = "The Waybar package to install.";
    };

    wm = mkOption {
      type = types.enum [
        "hyprland"
        "niri"
        "mangowm"
      ];
      default = "hyprland";
      description = "Window manager integration to use in Waybar.";
    };
  };

  config = mkIf cfg.enable {
    hj = {
      packages = [ cfg.package ];

      xdg.config.files."waybar/config.jsonc".text = ''
        {
          "layer": "top",
          "position": "top",
          "height": 24,
          "spacing": 0,
          "modules-left": ${builtins.toJSON modulesLeft},
          "modules-center": [],
          "modules-right": [
            "idle_inhibitor",
            "network",
            "pulseaudio",
            "battery",
            "clock",
            "tray"
          ],
          ${wmModuleSnippet}
          "idle_inhibitor": {
            "format": "{icon}",
            "format-icons": {
              "activated": "󰛐 ",
              "deactivated": "󰛑 "
            }
          },
          "network": {
            "interval": 1,
            "format-wifi": "󰖩 {bandwidthDownBytes} 󰕒 {bandwidthUpBytes} | {essid} ",
            "format-ethernet": "󰈀 {bandwidthDownBytes} 󰕒 {bandwidthUpBytes} | 󰈀 Eth ",
            "format-disconnected": "󰅛 ⚠ No Net ",
            "tooltip-format": "{ifname} via {gwaddr}",
            "max-length": 50
          },
          "pulseaudio": {
            "format": " {icon} {volume}% | {format_source} ",
            "format-muted": " 󰝟 Muted | {format_source} ",
            "format-source": "󰍬: {volume}%",
            "format-source-muted": "󰍭: MUTE",
            "format-icons": {
              "default": ["󰕿", "󰖀", "󰕾"]
            },
            "on-click": "${getExe pkgs.ponymix} -N -t sink toggle",
            "on-click-right": "${getExe pkgs.ponymix} -N -t source toggle"
          },
          "battery": {
            "states": {
              "warning": 30,
              "critical": 15
            },
            "format": " {icon} {capacity}% ",
            "format-charging": " 󱐋 {capacity}% ",
            "format-icons": ["󰁺", "󰁼", "󰁾", "󰂀", "󰁹"]
          },
          "clock": {
            "format": " 󰃭 {:%Y年%m月%d日  󱎫 %H:%M} ",
            "tooltip-format": "<tt><small>{calendar}</small></tt>"
          },
          "tray": {
            "icon-size": 20,
            "spacing": 8
          }
        }
      '';

      xdg.config.files."waybar/style.css".text = ''
        * {
          border: none;
          border-radius: 0;
          font-family: "${config.mine.fonts.terminal.name}", "${config.mine.fonts.icon.name}", "${config.mine.fonts.cjk.name}", sans-serif;
          font-size: ${toString config.mine.fonts.size}px;
          font-weight: 600;
          min-height: 0;
        }

        window#waybar {
          background-color: ${c.base00};
          color: ${c.base05};
        }

        #workspaces button,
        #tags button,
        #window,
        #idle_inhibitor,
        #network,
        #pulseaudio,
        #battery,
        #clock,
        #tray {
          padding: 0 10px;
          margin: 0;
        }

        #tags {
          background-color: ${c.base00};
          padding: 0;
        }

        #tags button {
          color: ${c.base03};
          padding: 0 12px;
        }

        #tags button:not(.occupied):not(.focused) {
          font-size: 0;
          min-width: 0;
          min-height: 0;
          margin: -17px;
          padding: 0;
          color: transparent;
          background-color: transparent;
        }

        #tags button.occupied {
          background-color: #fff;
          color: #cdc885;
        }

        #tags button.focused {
          background-color: rgb(186, 142, 213);
          color: #fff;
        }

        #tags button.urgent {
          background: rgb(171, 101, 101);
          color: #fff;
        }

        #workspaces {
          background-color: ${c.base00};
          padding: 0;
        }

        #workspaces button {
          color: ${c.base04};
          padding: 0 12px;
          background-color: transparent;
        }

        #workspaces button * {
          color: inherit;
        }

        #workspaces button:hover {
          background-color: ${c.base02};
          color: ${c.base05};
          box-shadow: none;
        }

        #workspaces button.active {
          background-color: ${c.base0D};
          color: ${c.base00};
        }

        #workspaces button.urgent {
          background-color: ${c.base08};
          color: ${c.base00};
        }

        #window {
          background-color: transparent;
          color: ${c.base04};
        }

        #idle_inhibitor {
          background-color: ${c.base08};
          color: ${c.base00};
          padding: 0 10px;
          margin: 0;
        }

        #idle_inhibitor.activated {
          background-color: ${c.base09};
          color: ${c.base00};
        }

        #network {
          background-color: ${c.base0C};
          color: ${c.base00};
        }

        #network.disconnected {
          background-color: ${c.base08};
          color: ${c.base00};
        }

        #pulseaudio {
          background-color: ${c.base0A};
          color: ${c.base00};
        }

        #pulseaudio.muted {
          background-color: ${c.base08};
          color: ${c.base00};
        }

        #battery {
          background-color: ${c.base0B};
          color: ${c.base00};
        }

        #battery.warning {
          background-color: ${c.base0A};
        }

        #battery.critical {
          background-color: ${c.base08};
          color: ${c.base00};
        }

        #clock {
          background-color: ${c.base0E};
          color: ${c.base00};
          margin-top: -3px;
        }

        #tray {
          background-color: ${c.base01};
        }
      '';
    };
  };
}
