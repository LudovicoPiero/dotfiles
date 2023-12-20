{
  config,
  lib,
  pkgs,
  inputs,
  ...
} @ args: let
  cfg = config.mine.waybar;
  inherit (lib) mkIf mkOption types;
  waybar-date = pkgs.writeShellScriptBin "waybar-date" ''
    date "+%a %d %b %Y"
  '';
in {
  options.mine.waybar = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Enable waybar and set configuration.
      '';
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      alsa-utils
      waybar-date
    ];

    programs.waybar = {
      enable = true;

      package = inputs.self.packages.${pkgs.system}.waybar;

      settings = {
        mainBar = {
          position = "bottom";
          monitor = "eDP-1";
          height = 25;
          modules-left = [
            "hyprland/workspaces"
            "river/tags"
            "sway/workspaces"
            "tray"
          ];
          modules-right = [
            "privacy"
            "network"
            "custom/wireguard"
            "custom/teavpn"
            "pulseaudio"
            "battery"
            "custom/date"
            "clock"
          ];
          "privacy" = {
            "icon-spacing" = 4;
            "icon-size" = 18;
            "transition-duration" = 250;
          };
          "pulseaudio" = {
            "format" = "{icon}{volume}%";
            "format-muted" = "󰖁";
            "on-click" = "amixer -q set Master toggle-mute";
            "format-icons" = ["󰕿" "󰖀" "󰕾"];
          };
          "hyprland/workspaces" = {
            # active-only = false;
            show-special = true;
            on-scroll-up = "hyprctl dispatch workspace r-1";
            on-scroll-down = "hyprctl dispatch workspace r+1";
            format = "{icon}";
            # persistent-workspaces = {"*" = 5;};
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
              "default" = "󰝥";
              "special" = "󰦥";
            };
          };
          "river/tags" = {
            "num-tags" = 9;
          };
          "sway/workspaces" = {
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
              "default" = "󰝥";
            };
          };
          "tray" = {
            spacing = 5;
          };
          "network" = {
            interface = "wlp4s0";
            format-wifi = "󰖩Connected";
            format-linked = "{ifname} (No IP)";
            format-disconnected = "󰖪Disconnected";
            tooltip-format-wifi = "Signal Strenght: {signalStrength}% | Down Speed: {bandwidthDownBits}, Up Speed: {bandwidthUpBits}";
          };
          "custom/wireguard" = {
            "format" = "󰌾Wireguard";
            "exec" = "echo '{\"class\": \"connected\"}'";
            "exec-if" = "test -d /proc/sys/net/ipv4/conf/wg0";
            "return-type" = "json";
            "interval" = 5;
          };
          "custom/teavpn" = {
            "format" = "󰌾TeaVPN";
            "exec" = "echo '{\"class\": \"connected\"}'";
            "exec-if" = "test -d /proc/sys/net/ipv4/conf/teavpn2-cl-01";
            "return-type" = "json";
            "interval" = 5;
          };
          "battery" = {
            bat = "BAT1";
            interval = 60;
            format = "{icon}{capacity}%";
            format-charging = "󰂄{capacity}%";
            states = {
              "good" = 95;
              "warning" = 20;
              "critical" = 10;
            };
            format-icons = [
              "󰁺"
              "󰁻"
              "󰁼"
              "󰁽"
              "󰁾"
              "󰁿"
              "󰂀"
              "󰂁"
              "󰂂"
              "󰁹"
            ];
          };
          "custom/date" = {
            format = "󰃭 {}";
            interval = 3600;
            exec = "${lib.getExe waybar-date}";
          };
          "clock" = {
            format = "󰅐 {:%I:%M %p}";
            tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
          };
        };
      };
      style = import ./style.nix args;
    };
  };
}
