{
  lib,
  pkgs,
  config,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    mkIf
    getExe
    getExe'
    ;

  cfg = config.mine.waybar;

  # Custom script for date with Japanese/English formatting
  waybar-date = pkgs.writeShellScriptBin "waybar-date" ''
    ja=$(LC_TIME=ja_JP.UTF-8 date "+%A, %Y年 %-m月 %-d日")
    en=$(LC_TIME=en_US.UTF-8 date "+%A, %B %-d, %Y")
    printf '{"text":"| DATE: %s ","tooltip":"%s"}\n' "$ja" "$en"
  '';
in
{
  options.mine.waybar = {
    enable = mkEnableOption "waybar";
  };

  config = mkIf cfg.enable {
    hj = {
      packages = [ pkgs.waybar ];
      xdg.config.files."waybar/config.jsonc" = {
        text = ''
          {
            "modules-center": [
                "hyprland/submap"
            ],
            "modules-left": [
                "custom/menu",
                "hyprland/workspaces",
                "niri/workspaces",
                "dwl/tags"
            ],
            "modules-right": [
                "tray",
                "idle_inhibitor",
                "mpd",
                "pulseaudio",
                "bluetooth",
                "network",
                "battery",
                "clock",
                "custom/date",
                "custom/power"
            ],
            "position": "bottom",
            "spacing": 6,
            "ipc": true,
            "layer": "top",
            "fixed-center": true,
            "height": 32,
            "backlight": {
                "format": "| BACKLIGHT: {percent}%",
                "interval": 2,
                "on-scroll-down": "${getExe pkgs.light} -U 5%",
                "on-scroll-up": "${getExe pkgs.light} -A 5%"
            },

            "battery": {
                "format": "| BAT: {capacity}%",
                "format-alt": "| BAT: {time}",
                "format-charging": "| BAT+: {capacity}%",
                "format-full": "| BAT: FULL",
                "format-plugged": "| BAT(AC): {capacity}%",
                "interval": 60,
                "tooltip": true
            },
            "bluetooth": {
                "format": "| BT {status}",
                "format-connected": "| BT {device_alias}",
                "format-connected-battery": "| BT {device_battery_percentage}%",
                "format-disabled": "| BT DIS",
                "format-off": "| BT OFF",
                "format-on": "| BT {status}",
                "tooltip": true
            },
            "clock": {
                "calendar": {
                    "format": {
                        "days": "<span color='#ecc6d9'><b>{}</b></span>",
                        "months": "<span color='#ffead3'><b>{}</b></span>",
                        "today": "<span color='#ff6699'><b><u>{}</u></b></span>",
                        "weekdays": "<span color='#ffcc66'><b>{}</b></span>",
                        "weeks": "<span color='#99ffdd'><b>W{}</b></span>"
                    },
                    "mode": "year"
                },
                "format": "| TIME: {:%I:%M %p}",
                "tooltip-format": "{calendar}"
            },
            "cpu": {
                "format": "| CPU: {usage}%",
                "interval": 5
            },
            "custom/date": {
                "exec": "${getExe waybar-date}",
                "interval": 3600,
                "return-type": "json"
            },
            "custom/disk_home": {
                "exec": "df -h --output=avail /dev/disk/by-label/HOME | tail -1 | tr -d ' '",
                "format": "| HOME: {}",
                "interval": 30,
                "tooltip-format": "Size of /home"
            },
            "custom/disk_root": {
                "exec": "df -h --output=avail / | tail -1 | tr -d ' '",
                "format": "| ROOT: {}",
                "interval": 30,
                "tooltip-format": "Size of /"
            },
            "custom/menu": {
                "format": "MENU",
                "on-click": "${getExe pkgs.fuzzel}",
                "tooltip": false
            },
            "custom/power": {
                "format": "POWER",
                "on-click": "${getExe pkgs.wleave}",
                "tooltip": false
            },
            "custom/tailscale": {
                "exec": "ip link show tailscale0 >/dev/null 2>&1 && echo '{\"class\": \"connected\"}' || echo '{}'",
                "format": "| TAILSCALE",
                "interval": 5,
                "return-type": "json"
            },
            "custom/wireguard": {
                "exec": "echo '{\"class\": \"connected\"}'",
                "exec-if": "test -d /proc/sys/net/ipv4/conf/wg0",
                "format": "| WIREGUARD",
                "interval": 5,
                "return-type": "json"
            },
            "dwl/tags": {
                "disable-click": false,
                "num-tags": 9
            },
            "dwl/window": {
                "format": "[{layout}]"
            },
            "ext/workspaces": {
                "format": "{name}",
                "on-click": "activate",
                "sort-by-id": true
            },
            "hyprland/submap": {
                "format": "| {}",
                "max-length": 8,
                "tooltip": false
            },
            "hyprland/workspaces": {
                "format": "{icon}",
                "on-click": "activate",
                "on-scroll-down": "${getExe' pkgs.hyprland "hyprctl"} dispatch workspace e+1",
                "on-scroll-up": "${getExe' pkgs.hyprland "hyprctl"} dispatch workspace e-1"
            },
            "idle_inhibitor": {
                "format": "| {icon}",
                "format-icons": {
                    "activated": "INHIBIT ON",
                    "deactivated": "INHIBIT OFF"
                }
            },
            "memory": {
                "format": "| MEM: {used:0.1f}G",
                "interval": 10
            },
            "mpd": {
                "artist-len": 8,
                "format": "| MPD: {stateIcon} {artist} - {title}",
                "format-disconnected": "| MPD DISCONNECTED",
                "format-paused": "| MPD PAUSED: {artist} - {title}",
                "format-stopped": "| MPD STOPPED",
                "interval": 2,
                "on-click": "${getExe pkgs.mpc} toggle",
                "on-click-middle": "${getExe pkgs.mpc} prev",
                "on-click-right": "${getExe pkgs.mpc} next",
                "on-scroll-down": "${getExe pkgs.mpc} seek -00:00:01",
                "on-scroll-up": "${getExe pkgs.mpc} seek +00:00:01",
                "state-icons": {
                    "paused": "PAUSE",
                    "playing": "PLAY"
                },
                "title-len": 12,
                "tooltip-format": "MPD (connected)",
                "tooltip-format-disconnected": "MPD (disconnected)"
            },
            "network": {
                "format-alt": "| IP LEAK: {ipaddr}/{cidr}",
                "format-disconnected": "| NET: DISCONNECTED",
                "format-ethernet": "| IP LEAK: {ipaddr}/{cidr}",
                "format-linked": "| IP LEAK: (No IP)",
                "format-wifi": "| NET: DOWN {bandwidthDownBits} UP {bandwidthUpBits}",
                "interval": 5
            },
            "niri/workspaces": {
                "format": "{value}",
                "on-click": "activate",
                "tooltip": false
            },
            "pulseaudio": {
                "format": "| VOL: {volume}% {format_source}",
                "format-bluetooth": "| VOL: BT {volume}% {format_source}",
                "format-bluetooth-muted": "| VOL: BT MUTE {format_source}",
                "format-muted": "| VOL: MUTE {format_source}",
                "format-source": "MIC: {volume}%",
                "format-source-muted": "MIC: MUTE",
                "on-click": "${getExe pkgs.ponymix} -N -t sink toggle",
                "on-click-right": "${getExe pkgs.ponymix} -N -t source toggle",
                "scroll-step": 5
            },
            "sway/workspaces": {
                "format": "{name}"
            },
            "tray": {
                "icon-size": 16,
                "spacing": 10
            }
          }
        '';
      };
    };
  };
}
