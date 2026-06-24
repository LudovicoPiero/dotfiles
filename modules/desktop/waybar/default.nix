{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    getExe
    getExe'
    mkIf
    ;
  cfg = config.mine.mango;
in
{
  config = mkIf cfg.enable {
    hj = {
      packages = [
        pkgs.waybar
        pkgs.pamixer
      ];
      xdg.config.files."waybar/config.jsonc".text = ''
        {
            "layer": "top",
            "height": 42,
            "spacing": 4,
            "modules-left": [ "ext/workspaces" ],
            "modules-right": [
                "tray",
                "cpu",
                "memory",
                "temperature",
                "pulseaudio",
                "battery",
                "clock"
            ],
            "ext/workspaces": {
              "format": "{icon}",
              "ignore-hidden": true,
              "on-click": "activate",
              "on-click-right": "deactivate",
              "on-scroll-up": "${getExe' cfg.package "mmsg"} dispatch viewtoleft_have_client",
              "on-scroll-down": "${getExe' cfg.package "mmsg"} dispatch viewtoright_have_client",
              "sort-by-id": true
            },
            "tray": {
                "icon-size": 21,
                "spacing": 10
            },
            "clock": {
              "format": " {:%H:%M %p}",
              "format-alt": " {:L%A, %d %b %Y}"
            },
            "cpu": {
              "interval": 2,
              "format": " {load}%"
            },
            "memory": {
                "format": " {}%"
            },
            "temperature": {
                "hwmon-path": "/sys/class/hwmon/hwmon4/temp1_input",
                "critical-threshold": 90,
                "format": "{icon} {temperatureC}°C",
                "tooltip": true,
                "tooltip-format": "{temperatureF}°F",
                "format-icons": ["", "", ""]
            },
            "battery": {
                "states": {
                    "warning": 30,
                    "critical": 15
                },
                "format": "{capacity}% {icon}",
                "format-full": "{capacity}% {icon}",
                "format-charging": "{capacity}% ",
                "format-plugged": "{capacity}% ",
                "format-alt": "{time} {icon}",
                "format-icons": ["", "", "", "", ""]
            },
            "pulseaudio": {
                "format": "{icon} {volume}%",
                "tooltip": false,
                "format-muted": " Muted",
                "on-click": "${getExe pkgs.pamixer} -t",
                "on-scroll-up": "${getExe' pkgs.pamixer "pamixer"} -i 2",
                "on-scroll-down": "${getExe' pkgs.pamixer "pamixer"} -d 2",
                "scroll-step": 5,
                "format-icons": {
                    "headphone": "",
                    "hands-free": "",
                    "headset": "",
                    "phone": "",
                    "portable": "",
                    "car": "",
                    "default": ["", "", ""]
                }
            }
        }
      '';
    };
  };
}
