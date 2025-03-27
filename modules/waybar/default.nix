{
  lib,
  pkgs,
  config,
  inputs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;

  _ = lib.getExe;

  waybar-date = pkgs.writeShellScriptBin "waybar-date" ''
    date "+%Y年%m月%d日"
  '';

  cfg = config.myOptions.waybar;
in
{
  options.myOptions.waybar = {
    enable = mkEnableOption "waybar" // {
      default = config.myOptions.hyprland.enable;
    };
  };

  config = mkIf cfg.enable {
    home-manager.users.${config.vars.username} = {
      imports = [ ./style.nix ];
      programs.waybar = {
        enable = true;

        # package = inputs.self.packages.${pkgs.stdenv.hostPlatform.system}.waybar;

        settings = {
          mainBar = {
            position = "bottom";
            height = 25;
            modules-left = [
              "hyprland/workspaces"
              "hyprland/submap"
              "tray"
            ];
            modules-right = [
              "custom/disk_root"
              "custom/disk_home"
              "privacy"
              "network"
              "custom/wireguard"
              "custom/teavpn"
              "pulseaudio"
              "battery"
              "custom/date"
              "clock"
            ];
            privacy = {
              icon-spacing = 4;
              icon-size = 18;
              transition-duration = 250;
              modules = [
                {
                  type = "screenshare";
                  tooltip = true;
                  tooltip-icon-size = 24;
                }
                {
                  type = "audio-out";
                  tooltip = true;
                  tooltip-icon-size = 24;
                }
                {
                  type = "audio-in";
                  tooltip = true;
                  tooltip-icon-size = 24;
                }
              ];
            };
            "pulseaudio" = {
              "on-click" = "${_ pkgs.ponymix} -N -t sink toggle";
              "on-click-right" = "${_ pkgs.ponymix} -N -t source toggle";

              "format" = "{icon}{volume}% {format_source}";
              "format-muted" = "󰖁{format_source}";
              "format-bluetooth" = "{icon}󰂯 {volume}% {format_source}";
              "format-bluetooth-muted" = "󰖁󰂯 {format_source}";
              "format-source" = "󰍬{volume}%";
              "format-source-muted" = "󰍭";
              "format-icons" = {
                "headphones" = "󰋋";
                "handsfree" = "󱡏";
                "headset" = "󰋋";
                "phone" = "";
                "portable" = "";
                "car" = "";
                "default" = [
                  "󰕿"
                  "󰖀"
                  "󰕾"
                ];
              };
            };
            "hyprland/workspaces" = {
              "all-outputs" = true;
              "format" = "{icon}";
              "on-click" = "activate";
              "on-scroll-up" = "hyprctl dispatch workspace e-1";
              "on-scroll-down" = "hyprctl dispatch workspace e+1";
              "persistent-workspaces" = {
                "1" = [ ];
                "2" = [ ];
                "3" = [ ];
                "4" = [ ];
                "5" = [ ];
                "6" = [ ];
                "7" = [ ];
                "8" = [ ];
                "9" = [ ];
                "10" = [ ];
              };
              "format-icons" = {
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
            "tray" = {
              spacing = 5;
            };
            "network" = {
              "format-alt" = "DOWN: {bandwidthDownBits} UP: {bandwidthUpBits}";
              "format-ethernet" = "󰈀IP LEAK: {ipaddr}/{cidr}";
              "format-linked" = "{ifname} (No IP)";
              "format-disconnected" = "⚠ Disconnected";
              "format-wifi" = "󰖩IP LEAK: {ipaddr}/{cidr}";
              "interval" = 5;
            };
            "custom/wireguard" = {
              "format" = "󰖂Wireguard";
              "exec" = "echo '{\"class\": \"connected\"}'";
              "exec-if" = "test -d /proc/sys/net/ipv4/conf/wg0";
              "return-type" = "json";
              "interval" = 5;
            };
            "custom/teavpn" = {
              "format" = "󰖂Teavpn";
              "exec" = "echo '{\"class\": \"connected\"}'";
              "exec-if" = "test -d /proc/sys/net/ipv4/conf/teavpn2-cl-01";
              "return-type" = "json";
              "interval" = 5;
            };
            "custom/disk_home" = {
              "format" = "󰋊Porn Folder: {}";
              "tooltip-format" = "Size of /home";
              "interval" = 30;
              "exec" = "df -h --output=avail /dev/disk/by-label/HOME | tail -1 | tr -d ' '";
            };
            "custom/disk_root" = {
              "format" = "󰋊Hentai Folder: {}";
              "tooltip-format" = "Size of /";
              "interval" = 30;
              "exec" = "df -h --output=avail / | tail -1 | tr -d ' '";
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
              "format" = "󰃭{}";
              "interval" = 3600;
              "exec" = "${_ waybar-date}";
            };
            "clock" = {
              "format" = "󰅐{:%I:%M %p}";
              "format-alt" = "󰃭{:%A; %B %d, %Y (%R)}";
              "tooltip-format" = "<tt><small>{calendar}</small></tt>";
              "calendar" = {
                "mode" = "year";
                "mode-mon-col" = 3;
                "weeks-pos" = "right";
                "on-scroll" = 1;
                "format" = {
                  "months" = "<span color='#ffead3'><b>{}</b></span>";
                  "days" = "<span color='#ecc6d9'><b>{}</b></span>";
                  "weeks" = "<span color='#99ffdd'><b>W{}</b></span>";
                  "weekdays" = "<span color='#ffcc66'><b>{}</b></span>";
                  "today" = "<span color='#ff6699'><b><u>{}</u></b></span>";
                };
              };
              "actions" = {
                "on-click-right" = "mode";
                "on-scroll-up" = "shift_up";
                "on-scroll-down" = "shift_down";
              };
            };
          };
        };
      };
    };
  };
}
