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
          "modules-left": [
            "niri/workspaces",
            "niri/window"
          ],
          "modules-center": [],
          "modules-right": [
            "idle_inhibitor",
            "network",
            "pulseaudio",
            "battery",
            "clock",
            "tray"
          ],
          "niri/workspaces": {
            // "format": "{index} {value}"
            "format": "{icon}",
            "format-icons": {
              "main": "1 main",
              "chat": "2 chat",
              "mail": "3 mail",
              "default": ""
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
          "idle_inhibitor": {
            "format": "{icon}",
            "format-icons": {
              "activated": "",
              "deactivated": ""
            }
          },
          "network": {
            "interval": 1, // Update every second to show real-time speed
            "format-wifi": "  {bandwidthDownBytes}  {bandwidthUpBytes} |  {essid} ",
            "format-ethernet": "  {bandwidthDownBytes}  {bandwidthUpBytes} | 󰈀 Eth ",
            "format-disconnected": " ⚠ No Net ",
            "tooltip-format": "{ifname} via {gwaddr}",
            "max-length": 50 // Increased to fit the speed text
          },
          "pulseaudio": {
            "format": " {icon} {volume}% | {format_source} ",
            "format-muted": "  Muted | {format_source} ",
            "format-source": ": {volume}%",
            "format-source-muted": ": MUTE",
            "format-icons": {
              "default": [
                "",
                "",
                ""
              ]
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
            "format-charging": "  {capacity}% ",
            "format-icons": [
              "",
              "",
              "",
              "",
              ""
            ]
          },
          "clock": {
            "format": "  {:%Y年%m月%d日   %H:%M} ",
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
          /* semibold */
          font-weight: 600;
          min-height: 0;
        }

        window#waybar {
          background-color: #1a1b26;
          color: #c0caf5;
        }

        #workspaces button,
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

        #workspaces {
          background-color: #16161e;
          padding: 0;
        }

        #workspaces button {
          color: #565f89;
          padding: 0 12px;
        }

        #workspaces button.active {
          background-color: #7aa2f7;
          color: #16161e;
        }

        #workspaces button.urgent {
          background-color: #f7768e;
          color: #16161e;
        }

        #window {
          background-color: transparent;
          color: #a9b1d6;
        }

        #idle_inhibitor {
          background-color: #f7768e;
          color: #16161e;
          padding: 0 10px;
          margin: 0;
        }

        #idle_inhibitor.activated {
          background-color: #ff9e64;
          color: #16161e;
        }

        #network {
          background-color: #2ac3de;
          color: #16161e;
        }

        #network.disconnected {
          background-color: #f7768e;
          color: #16161e;
        }

        #pulseaudio {
          background-color: #e0af68;
          color: #16161e;
        }

        #pulseaudio.muted {
          background-color: #f7768e;
          color: #16161e;
        }

        #battery {
          background-color: #9ece6a;
          color: #16161e;
        }

        #battery.warning {
          background-color: #e0af68;
        }

        #battery.critical {
          background-color: #f7768e;
          color: #16161e;
        }

        #clock {
          background-color: #bb9af7;
          color: #16161e;
          margin-top: -3px;
        }

        #tray {
          background-color: #24283b;
        }
      '';
    };
  };
}
