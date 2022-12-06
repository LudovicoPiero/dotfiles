{
  pkgs,
  lib,
  inputs,
  config,
  ...
} @ args: {
  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        position = "top";
        monitor = "eDP-1";
        layer = "bottom";
        height = 30;

        modules-left = ["wlr/workspaces" "tray"];
        modules-right = [
          #   "wlr/workspaces"
          #   "tray"
          "network"
          "pulseaudio"
          "battery"
          "custom/date"
          "clock"
        ];

        "wlr/workspaces" = {
          on-click = "activate";
          active-only = false;
          disable-scroll = true;
          all-outputs = true;
          format = "{icon}";
          format-icons = {
            "1" = "1";
            "2" = "2";
            "3" = "3";
            "4" = "4";
            "5" = "5";
            "6" = "6";
            "7" = "7";
            "8" = "8";
            "9" = "9";
            "10" = "10";
            "active" = "";
            "default" = "";
          };
        };
        "tray" = {
          spacing = 5;
        };
        "network" = {
          interface = "wlp3s0";
          format-wifi = "  Connected";
          format-linked = "{ifname} (No IP)";
          format-disconnected = "  Disconnected";
          tooltip-format-wifi = "Signal Strenght: {signalStrength}% | Down Speed: {bandwidthDownBits}, Up Speed: {bandwidthUpBits}";
        };
        "pulseaudio" = {
          format = "{icon} {volume}%";
          on-click = "amixer -q set Master toggle-mute";
          format-muted = "󰖁 Muted";
          format-icons = {
            "headphone" = " ";
            "default" = " ";
          };
        };
        "battery" = {
          bat = "BAT1";
          interval = 60;
          format = "{icon} {capacity}%";
          format-charging = " {capacity}%";
          states = {
            "good" = 95;
            "warning" = 20;
            "critical" = 10;
          };
          format-icons = [
            " "
            " "
            " "
            " "
            " "
          ];
        };
        "custom/date" = {
          format = "  {}";
          interval = 3600;
          exec = pkgs.writeShellScript "waybar-date" ''
            date "+%a %d %b %Y"
          '';
        };
        "clock" = {
          format = " {:%I:%M %p}";
          tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
        };
      };
    };
    style = import ./style.nix args;
  };
}
