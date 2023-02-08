{
  config,
  pkgs,
  lib,
  inputs,
  ...
} @ args: let
  waybar-date = pkgs.writeShellScriptBin "waybar-date" ''
    date "+%a %d %b %Y"
  '';
in {
  home-manager.users."${config.vars.username}" = {
    home.packages = with pkgs; [
      alsa-utils
      waybar-date
    ];
    programs.waybar = {
      enable = true;
      package = inputs.hyprland.packages.${pkgs.system}.waybar-hyprland;
      settings = {
        mainBar = {
          position = "top";
          monitor = "eDP-1";
          layer = "top";
          mode = "dock";
          height = 30;
          # width = "";
          spacing = 6;
          margin = "0";
          margin-top = 0;
          margin-bottom = 0;
          margin-left = 0;
          margin-right = 0;
          fixed-center = true;
          # ipc = true;

          modules-left = ["wlr/workspaces" "tray"];
          modules-right = [
            "cpu"
            "memory"
            "network"
            "pulseaudio"
            "battery"
            "custom/date"
            "clock"
          ];
          "pulseaudio" = {
            "format" = "{icon} {volume}%";
            "format-muted" = "婢";
            "on-click" = "amixer -q set Master toggle-mute";
            "format-icons" = ["奄" "墳" "墳"];
          };
          "cpu" = {
            "interval" = 10;
            "format" = " {}%";
            "max-length" = 10;
          };
          "memory" = {
            "interval" = 30;
            "format" = " {}%";
            "max-length" = 10;
          };
          "wlr/workspaces" = {
            on-click = "activate";
            active-only = false;
            disable-scroll = true;
            all-outputs = true;
            format = "{icon}";
            format-icons = {
              "1" = "DEV";
              "2" = "WWW";
              "3" = "CHAT";
              "4" = "MUSIC";
              "5" = "MISC";
              # "6" = "6";
              # "7" = "7";
              # "8" = "8";
              # "9" = "9";
              # "10" = "10";
              # "active" = "";
              "default" = "";
            };
          };
          "tray" = {
            spacing = 5;
          };
          "network" = {
            interface = "wlp4s0";
            format-wifi = "  Connected";
            format-linked = "{ifname} (No IP)";
            format-disconnected = "  Disconnected";
            tooltip-format-wifi = "Signal Strenght: {signalStrength}% | Down Speed: {bandwidthDownBits}, Up Speed: {bandwidthUpBits}";
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
            exec = "${lib.getExe waybar-date}";
          };
          "clock" = {
            format = " {:%I:%M %p}";
            tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
          };
        };
      };
      style = import ./style.nix args;
    };
  };
}
