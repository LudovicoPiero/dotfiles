{
  pkgs,
  lib,
}: {
  mainBar = {
    position = "bottom";
    monitor = "eDP-1";
    height = 25;

    modules-left = [
      "wlr/workspaces"
      "tray"
    ];
    modules-right = [
      "custom/vpn"
      "network"
      "pulseaudio"
      "battery"
      "custom/date"
      "clock"
    ];
    "pulseaudio" = {
      "format" = "{icon} {volume}%";
      "format-muted" = "󰝟";
      "on-click" = "amixer -q set Master toggle-mute";
      "format-icons" = ["" "" ""];
    };
    "cpu" = {
      "interval" = 10;
      "format" = " {}%";
      "max-length" = 10;
    };
    "memory" = {
      "interval" = 30;
      "format" = " {}%";
      "max-length" = 10;
    };
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
        # "active" = "";
        "default" = "";
      };
    };
    "sway/workspaces" = {
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
        # "active" = "";
        "default" = "";
      };
    };
    "tray" = {
      spacing = 5;
    };
    "custom/vpn" = {
      "format" = "Wireguard ";
      "exec" = "echo '{\"class\": \"connected\"}'";
      "exec-if" = "test -d /proc/sys/net/ipv4/conf/wg0";
      "return-type" = "json";
      "interval" = 5;
    };
    "network" = {
      # interface = "wlp4s0";
      format-wifi = "  Connected";
      format-linked = "{ifname} (No IP)";
      format-disconnected = "󰖪  Disconnected";
      tooltip-format-wifi = "Signal Strenght: {signalStrength}% | Down Speed: {bandwidthDownBits}, Up Speed: {bandwidthUpBits}";
    };
    "battery" = {
      bat = "BAT1";
      interval = 60;
      format = "{icon} {capacity}%";
      format-charging = "󰂄 {capacity}%";
      states = {
        "good" = 95;
        "warning" = 20;
        "critical" = 10;
      };
      format-icons = [
        " "
        " "
        ""
        " "
        " "
      ];
    };
    "custom/date" = let
      waybar-date = pkgs.writers.writeDashBin "waybar-date" ''
        date "+%a %d %b %Y"
      '';
    in {
      format = "  {}";
      interval = 3600;
      exec = "${lib.getExe waybar-date}";
    };
    "clock" = {
      format = " {:%I:%M %p}";
      tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
    };
  };
}
