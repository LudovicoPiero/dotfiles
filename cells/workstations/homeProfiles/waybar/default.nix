{
  lib,
  pkgs,
  inputs,
  config,
  ...
}:
let
  waybar-date = pkgs.writeShellScriptBin "waybar-date" ''
    date "+%a %d %b %Y"
  '';
in
{
  home.packages = with pkgs; [ alsa-utils ];

  programs.waybar = {
    enable = config.wayland.windowManager.hyprland.enable;
    style = ./__style.css;

    package = pkgs.waybar;
    # package = inputs.ludovico-nixpkgs.packages.${pkgs.system}.waybar;

    settings = {
      # Thanks to @chborli on Hyprland's discord server
      mainBar = {
        "layer" = "top";
        "exclusive" = true;
        "passthrough" = false;
        "position" = "bottom";
        "spacing" = 3;
        "fixed-center" = true;
        "ipc" = true;

        "modules-left" = [
          "hyprland/workspaces"
          "custom/separator#line"
          "custom/teavpn"
          "custom/wireguard"
          "privacy"
        ];

        "modules-right" = [
          "tray"
          "custom/separator#line"
          "wireplumber"
          "custom/separator#line"
          "network"
          "custom/separator#line"
          "battery"
          "custom/separator#line"
          "custom/date"
          "custom/separator#line"
          "clock"
          "custom/separator#line"
          "custom/power"
        ];

        "custom/app#discord" = {
          "format" = "{} 󰙯";
          "tooltip" = false;
          "on-click" = "vesktop";
        };

        "custom/app#firefox" = {
          "format" = "{} 󰈹 ";
          "tooltip" = false;
          "on-click" = "firefox";
        };

        "custom/app#steam" = {
          "format" = "{}  ";
          "tooltip" = false;
          "on-click" = "steam";
        };
        "custom/app#term" = {
          "format" = "{}  ";
          "tooltip" = false;
          "on-click" = "kitty";
        };

        "custom/teavpn" = {
          "format" = "󰌾 TeaVPN";
          "exec" = "echo '{\"class\": \"connected\"}'";
          "exec-if" = "test -d /proc/sys/net/ipv4/conf/teavpn2-cl-01";
          "return-type" = "json";
          "interval" = 5;
        };

        "custom/wireguard" = {
          "format" = "󰌾 Wireguard";
          "exec" = "echo '{\"class\": \"connected\"}'";
          "exec-if" = "test -d /proc/sys/net/ipv4/conf/wg0";
          "return-type" = "json";
          "interval" = 5;
        };

        "hyprland/workspaces" = {
          "active-only" = false;
          "all-outputs" = true;
          "format" = "{icon}";
          "show-special" = false;
          "on-click" = "activate";
          "on-scroll-up" = "hyprctl dispatch workspace e-1";
          "on-scroll-down" = "hyprctl dispatch workspace e+1";
          "persistent-workspaces" = {
            "1" = [ ];
            "2" = [ ];
            "3" = [ ];
            "4" = [ ];
            "5" = [ ];
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

        "battery" = {
          "align" = 0;
          "rotate" = 0;
          "full-at" = 100;
          "design-capacity" = false;
          "states" = {
            "good" = 95;
            "warning" = 30;
            "critical" = 15;
          };
          "format" = "{icon} {capacity}%";
          "format-charging" = "{capacity}%";
          "format-plugged" = "󱘖 {capacity}%";
          "format-alt-click" = "click";
          "format-full" = "{icon} Full";
          "format-alt" = "{icon} {time}";
          "format-icons" = [
            "󰂎"
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
          "format-time" = "{H}h {M}min";
          "tooltip" = true;
          "tooltip-format" = "{timeTo} {power}w";
        };

        "bluetooth" = {
          "format" = " ";
          "format-disabled" = "󰂳";
          "format-connected" = "󰂱 {num_connections}";
          "tooltip-format" = " {device_alias}";
          "tooltip-format-connected" = "{device_enumerate}";
          "tooltip-format-enumerate-connected" = " {device_alias} 󰂄{device_battery_percentage}%";
          "tooltip" = true;
          "on-click" = "blueman-manager";
        };

        "clock" = {
          "interval" = 1;
          "format" = " {:%I:%M %p}";
          "format-alt" = " {:%H:%M   %Y; %d %B, %A}";
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
        };
        "actions" = {
          "on-click-right" = "mode";
          "on-click-forward" = "tz_up";
          "on-click-backward" = "tz_down";
          "on-scroll-up" = "shift_up";
          "on-scroll-down" = "shift_down";
        };

        "cpu" = {
          "format" = "{usage}% 󰍛";
          "interval" = 1;
          "format-alt-click" = "click";
          "format-alt" = "{icon0}{icon1}{icon2}{icon3} {usage:>2}% 󰍛";
          "format-icons" = [
            "▁"
            "▂"
            "▃"
            "▄"
            "▅"
            "▆"
            "▇"
            "█"
          ];
          "on-click-right" = "gnome-system-monitor";
        };

        "custom/date" = {
          format = "󰸗 {}";
          interval = 3600;
          exec = "${lib.getExe waybar-date}";
        };

        "disk" = {
          "interval" = 30;
          #"format"= "󰋊";
          "path" = "/";
          #"format-alt-click"= "click";
          "format" = "{percentage_used}% 󰋊";
          ##"tooltip"= true;
          "tooltip-format" = "{used} used out of {total} on {path} ({percentage_used}%)";
        };

        "hyprland/window" = {
          "format" = "{}";
          "max-length" = 40;
          "separate-outputs" = true;
          "offscreen-css" = true;
          "offscreen-css-text" = "(inactive)";
          "rewrite" = {
            "(.*) — Mozilla Firefox" = " $1";
            "(.*) - fish" = "> [$1]";
            "(.*) - zsh" = "> [$1]";
            "(.*) - kitty" = "> [$1]";
          };
        };

        "idle_inhibitor" = {
          "format" = "{icon}";
          "format-icons" = {
            "activated" = " ";
            "deactivated" = " ";
          };
        };

        "keyboard-state" = {
          ##"numlock"= true;
          "capslock" = true;
          "format" = {
            "numlock" = "N {icon}";
            "capslock" = "󰪛 {icon}";
          };
          "format-icons" = {
            "locked" = "";
            "unlocked" = "";
          };
        };

        "memory" = {
          "interval" = 10;
          "format" = "{used:0.1f}G 󰾆";
          "format-alt" = "{percentage}% 󰾆";
          "format-alt-click" = "click";
          "tooltip" = true;
          "tooltip-format" = "{used:0.1f}GB/{total:0.1f}G";
        };

        "network" = {
          "format" = "{ifname}";
          "format-wifi" = "{icon}";
          "format-ethernet" = "󰈀";
          "format-disconnected" = "󰌙 Disconnected";
          "tooltip-format" = "{ipaddr}  {bandwidthUpBytes}  {bandwidthDownBytes}";
          "format-linked" = "󰈁 {ifname} (No IP)";
          "tooltip-format-wifi" = "{essid} {icon} {signalStrength}%";
          "tooltip-format-ethernet" = "{ifname} 󰌘";
          "tooltip-format-disconnected" = "󰌙 Disconnected";
          "max-length" = 50;
          "format-icons" = [
            "󰤯"
            "󰤟"
            "󰤢"
            "󰤥"
            "󰤨"
          ];
        };

        "network#speed" = {
          "interval" = 1;
          "format" = "{ifname}";
          "format-wifi" = "{icon}  {bandwidthUpBytes}  {bandwidthDownBytes}";
          "format-ethernet" = "󰌘   {bandwidthUpBytes}  {bandwidthDownBytes}";
          "format-disconnected" = "󰌙";
          "tooltip-format" = "{ipaddr}";
          "format-linked" = "󰈁 {ifname} (No IP)";
          "tooltip-format-wifi" = "{essid} {icon} {signalStrength}%";
          "tooltip-format-ethernet" = "{ifname} 󰌘";
          "tooltip-format-disconnected" = "󰌙 Disconnected";
          "max-length" = 50;
          "format-icons" = [
            "󰤯"
            "󰤟"
            "󰤢"
            "󰤥"
            "󰤨"
          ];
        };

        "privacy" = {
          "icon-spacing" = 4;
          "icon-size" = 15;
          "transition-duration" = 250;
        };

        "tray" = {
          "icon-size" = 15;
          "spacing" = 8;
        };

        "wireplumber" = {
          "format" = "{icon} {volume} %";
          "format-muted" = " Mute";
          "on-click" = "${lib.getExe' pkgs.alsa-utils "amixer"} set Master toggle";
          "on-click-right" = "pavucontrol -t 3";
          "on-scroll-up" = "${lib.getExe' pkgs.alsa-utils "amixer"} -q set Master 5%+";
          "on-scroll-down" = "${lib.getExe' pkgs.alsa-utils "amixer"} -q set Master 5%-";
          "format-icons" = [
            ""
            ""
            "󰕾"
            ""
          ];
        };

        "wlr/taskbar" = {
          "format" = " {icon} ";
          "icon-size" = 15;
          "all-outputs" = false;
          "tooltip-format" = "{title}";
          "on-click" = "activate";
          "on-click-middle" = "close";
          "ignore-list" = [
            "wofi"
            "rofi"
            "org.wezfurlong.wezterm"
            "Spotify"
          ];
        };

        "custom/menu" = {
          "format" = "󱄅{}";
          "exec" = "echo ; echo 󱓟 app launcher";
          "interval" = 86400; # once every day
          "tooltip" = true;
          "on-click" = "${lib.getExe pkgs.fuzzel}";
        };

        "custom/power" = {
          "format" = "󰐥 ";
          # "exec"= "echo ; echo 󰟡 power // blur";
          "on-click" = "${lib.getExe pkgs.wlogout}";
          # "interval"= 86400; // once every day
          "tooltip" = true;
        };

        # Separators
        "custom/separator#dot" = {
          "format" = "";
          "interval" = "once";
          "tooltip" = false;
        };

        "custom/separator#dot-line" = {
          "format" = "";
          "interval" = "once";
          "tooltip" = false;
        };

        "custom/separator#line" = {
          "format" = "|";
          "interval" = "once";
          "tooltip" = false;
        };

        "custom/separator#blank" = {
          "format" = "";
          "interval" = "once";
          "tooltip" = false;
        };

        "custom/separator#blank_2" = {
          "format" = "  ";
          "interval" = "once";
          "tooltip" = false;
        };

        "custom/separator#blank_3" = {
          "format" = "   ";
          "interval" = "once";
          "tooltip" = false;
        };
      };
    };
  };
}
