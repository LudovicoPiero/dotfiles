{
  lib,
  pkgs,
  config,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf getExe;

  cfg = config.mine.waybar;

  # Custom script for date with Japanese/English formatting
  waybar-date = pkgs.writeShellScriptBin "waybar-date" ''
    export LOCALE_ARCHIVE="${pkgs.glibcLocales}/lib/locale/locale-archive"
    ja=$(LC_ALL=ja_JP.UTF-8 date "+%A, %Y年 %-m月 %-d日")
    en=$(LC_ALL=en_US.UTF-8 date "+%A, %B %-d, %Y")

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
            "position": "bottom",
            "layer": "top",
            "height": 24,
            "spacing": 0,
            "modules-left": [
                "hyprland/workspaces",
                "dwl/tags"
            ],
            "modules-right": [
                "tray",
                "idle_inhibitor",
                "mpd",
                "network",
                "pulseaudio",
                "battery",
                "clock",
                "custom/date"
            ],
            "idle_inhibitor": {
                "format": "| {icon}",
                "format-icons": {
                    "activated": "INHIBIT ON",
                    "deactivated": "INHIBIT OFF"
                }
            },
            "custom/date": {
                "exec": "${getExe waybar-date}",
                "interval": 3600,
                "return-type": "json"
            },
            "hyprland/workspaces": {
                "format": "{name}",
                "on-click": "activate",
                "sort-by-number": true
            },
            "dwl/tags": {
                "num-tags": 9
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
            "network": {
                "format-alt": "| IP LEAK: {ipaddr}/{cidr}",
                "format-disconnected": "| NET: DISCONNECTED",
                "format-ethernet": "| IP LEAK: {ipaddr}/{cidr}",
                "format-linked": "| IP LEAK: (No IP)",
                "format-wifi": "| NET: DOWN {bandwidthDownBits} UP {bandwidthUpBits}",
                "interval": 5
            },
            "disk": {
                "format": "| HDD: {percentage_used}%",
                "path": "/",
                "interval": 60,
                "tooltip": false
            },
            "memory": {
                "format": "| RAM: {used:0.1f}G",
                "interval": 10,
                "tooltip": false
            },
            "cpu": {
                "format": "| CPU: {usage}%",
                "interval": 5,
                "tooltip": false
            },
            "battery": {
                "format": "| BAT: {capacity}%",
                "format-charging": "| CHR: {capacity}%",
                "format-plugged": "| AC: {capacity}%",
                "states": {
                    "warning": 30,
                    "critical": 15
                },
                "tooltip": false
            },
            "clock": {
                "format": "| TIME: {:%I:%M %p}",
                "tooltip": "{calendar}"
            },
            "tray": {
                "icon-size": 14,
                "spacing": 5
            }
          }
        '';
      };
    };
  };
}
