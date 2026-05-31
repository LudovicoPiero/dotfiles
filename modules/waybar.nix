{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    getExe'
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

    wm = mkOption {
      type = types.enum [
        "hyprland"
        "niri"
        "mangowm"
      ];
      default = "hyprland";
      description = "Window manager integration to use in Waybar.";
    };

    position = mkOption {
      type = types.enum [
        "top"
        "bottom"
      ];
      default = "bottom";
      description = "Bar position.";
    };
  };

  config = mkIf cfg.enable {
    hj = {
      packages = [ cfg.package ];

      xdg.config.files."waybar/config.jsonc".text = ''
        {
          "layer": "top",
          "position": "${cfg.position}",
          "height": 20,
          "spacing": 0,
          "modules-left": [
            ${
              if cfg.wm == "hyprland" then
                ''"hyprland/workspaces"''
              else if cfg.wm == "niri" then
                ''"niri/workspaces"''
              else
                ''"ext/workspaces"''
            }
          ],
          "modules-center": [],
          "modules-right": [
            "temperature",
            "network",
            "disk",
            "battery",
            "load",
            "clock",
            "tray"
          ],
          "hyprland/workspaces": {
            "format": "{id}",
            "format-window-separator": " "
          },
          "niri/workspaces": {
            "format": "{name}",
            "format-window-separator": " "
          },
          "ext/workspaces": {
            "format": "{id}",
            "format-window-separator": " ",
            "on-click": "activate",
            "on-click-right": "deactivate"
          },
          "temperature": {
            "critical-threshold": 80,
            "format": "Temp: {temperatureC}°C",
            "hwmon-path": "/sys/class/hwmon/hwmon3/temp1_input"
          },
          "network": {
            "interval": 5,
            "interface": "wlp4s0",
            "format-wifi": "W: ({signalStrength}%) IP Leak: {ipaddr}",
            "format-ethernet": "E: {ipaddr} ({bandwidthDownBytes})",
            "format-disconnected": "W: down | E: down",
            "tooltip-format": "{ifname}: {ipaddr}",
            "on-click": "${getExe' pkgs.networkmanagerapplet "nm-connection-editor"}"
          },
          "disk": {
            "interval": 30,
            "format": "Porn Folder: {free}",
            "path": "/"
          },
          "battery": {
            "states": {
              "good": 80,
              "warning": 30,
              "critical": 15
            },
            "bat": "BAT1",
            "format": "{capacity}% {time}",
            "interval": 60
          },
          "load": {
            "format": "Loads: {load1}",
            "interval": 5
          },
          "clock": {
            "format": "{:%Y-%m-%d %H:%M:%S}",
            "interval": 1
          },
          "tray": {
            "icon-size": 16,
            "spacing": 4
          }
        }
      '';

      xdg.config.files."waybar/style.css".text = ''
        * {
          border: none;
          border-radius: 0;
          font-family: "monospace";
          font-size: 12px;
          font-weight: normal;
          min-height: 0;
          margin: 0;
          padding: 0;
        }

        window#waybar {
          background-color: #222222;
          color: #ffffff;
          font-size: 12px;
        }

        #workspaces {
          background-color: #222222;
          padding: 0;
          margin: 0;
          border-right: 1px solid #333333;
        }

        #workspaces button {
          background-color: #222222;
          color: #ffffff;
          border: none;
          border-bottom: 2px solid transparent;
          padding: 4px 8px;
          margin: 0;
          min-width: 20px;
        }

        #workspaces button:hover {
          background-color: #333333;
        }

        #workspaces button.active {
          background-color: #285577;
          border-bottom-color: #ffffff;
        }

        #workspaces button.urgent {
          background-color: #900000;
        }

        #temperature {
          padding: 4px 12px;
          background-color: #222222;
          color: #ffffff;
          border-left: 1px solid #333333;
        }

        #temperature.critical {
          color: #ff0000;
        }

        #network {
          padding: 4px 12px;
          background-color: #222222;
          color: #ffffff;
          border-left: 1px solid #333333;
        }

        #network.disconnected {
          color: #ff0000;
        }

        #disk {
          padding: 4px 12px;
          background-color: #222222;
          color: #ffffff;
          border-left: 1px solid #333333;
        }

        #disk.warning {
          color: #ffff00;
        }

        #disk.critical {
          color: #ff0000;
        }

        #battery {
          padding: 4px 12px;
          background-color: #222222;
          color: #ffffff;
          border-left: 1px solid #333333;
        }

        #battery.warning {
          color: #ffff00;
        }

        #battery.critical {
          color: #ff0000;
        }

        #battery.charging {
          color: #00ff00;
        }

        #load {
          padding: 4px 12px;
          background-color: #222222;
          color: #ffffff;
          border-left: 1px solid #333333;
        }

        #clock {
          padding: 4px 12px;
          background-color: #222222;
          color: #ffffff;
          border-left: 1px solid #333333;
        }

        #tray {
          padding: 4px 8px;
          margin: 0;
          background-color: #222222;
          border-left: 1px solid #333333;
        }

        #tray > .passive {
          -gtk-icon-effect: dim;
        }

        #tray > .needs-attention {
          -gtk-icon-effect: highlight;
          background-color: #285577;
        }
      '';
    };
  };
}
