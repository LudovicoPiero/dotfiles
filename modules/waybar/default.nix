{
  lib,
  pkgs,
  palette,
  config,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;

  _ = lib.getExe;
  json = pkgs.formats.json { };
  cfg = config.myOptions.waybar;
in
{
  options.myOptions.waybar = {
    enable = mkEnableOption "waybar" // {
      default = config.myOptions.hyprland.enable;
    };
  };

  config = mkIf cfg.enable {
    hj = {
      packages = [ pkgs.waybar ];

      files = {
        ".config/waybar/config".source = (
          json.generate "config" {
            layer = "top";
            exclusive = true;
            passthrough = false;
            position = "bottom";
            height = 32;
            spacing = 6;
            margin = "0";
            margin-top = 0;
            margin-bottom = 0;
            margin-left = 0;
            margin-right = 0;
            fixed-center = true;
            ipc = true;
            modules-left = [
              "custom/menu"
              "cpu"
              "memory"
              "custom/disk_home"
              "custom/disk_root"
              "idle_inhibitor"
              "tray"
            ];
            modules-center = [
              "hyprland/workspaces"
              "hyprland/submap"
              # "mpd"
            ];
            modules-right = [
              "pulseaudio"
              "backlight"
              "bluetooth"
              "network"
              "battery"
              "clock"
              "custom/power"
            ];
            backlight = {
              interval = 2;
              align = 0;
              rotate = 0;
              format = "{icon} {percent}%";
              format-icons = [
                "󱩎"
                "󱩒"
                "󰛨"
              ];
              on-click = "";
              on-click-middle = "";
              on-click-right = "";
              on-update = "";
              on-scroll-up = "${_ pkgs.light} -A 5%";
              on-scroll-down = "${_ pkgs.light} -U 5%";
              smooth-scrolling-threshold = 1;
            };
            battery = {
              interval = 60;
              align = 0;
              rotate = 0;
              full-at = 100;
              design-capacity = false;
              states = {
                good = 95;
                warning = 30;
                critical = 15;
              };
              format = "{icon} {capacity}%";
              format-charging = " {capacity}%";
              format-plugged = " {capacity}%";
              format-full = "{icon} Full";
              format-alt = "{icon} {time}";
              format-icons = [
                ""
                ""
                ""
                ""
                ""
              ];
              format-time = "{H}h {M}min";
              tooltip = true;
            };
            bluetooth = {
              format = "󰂯{status}";
              format-on = "󰂯{status}";
              format-off = "󰂲{status}";
              format-disabled = "󰂲{status}";
              format-connected = "󰂯{device_alias}";
              format-connected-battery = "󰂯{device_alias}, {device_battery_percentage}%";
              tooltip = true;
              tooltip-format = "{controller_alias}\t{controller_address}";
              tooltip-format-connected = "{controller_alias}\t{controller_address}\n\n{device_enumerate}";
              tooltip-format-enumerate-connected = "{device_alias}\t{device_address}";
            };
            clock = {
              interval = 60;
              align = 0;
              rotate = 0;
              tooltip-format = "<big>{:%B %Y}</big>\n<tt><small>{calendar}</small></tt>";
              format = " {:%I:%M %p}";
              format-alt = " {:%a %b %d, %G}";
            };
            cpu = {
              interval = 5;
              format = "󰻠 LOAD: {usage}%";
            };
            "custom/menu" = {
              format = "󰚅";
              tooltip = false;
              on-click = "${_ pkgs.fuzzel}";
            };
            "custom/power" = {
              format = "󰐥";
              tooltip = false;
              on-click = "${_ pkgs.wlogout}";
            };
            "custom/disk_home" = {
              "format" = "󰋊 HOME: {}";
              "tooltip-format" = "Size of /home";
              "interval" = 30;
              "exec" = "df -h --output=avail /dev/disk/by-label/HOME | tail -1 | tr -d ' '";
            };
            "custom/disk_root" = {
              "format" = "󰋊 ROOT: {}";
              "tooltip-format" = "Size of /";
              "interval" = 30;
              "exec" = "df -h --output=avail / | tail -1 | tr -d ' '";
            };
            memory = {
              interval = 10;
              format = "󰍛 USED: {used:0.1f}G";
            };
            mpd = {
              interval = 2;
              unknown-tag = "N/A";
              format = "{stateIcon} {artist} - {title}";
              format-disconnected = "󰎊 Disconnected";
              format-paused = "{stateIcon} {artist} - {title}";
              format-stopped = "Stopped ";
              state-icons = {
                paused = "";
                playing = "";
              };
              tooltip-format = "MPD (connected)";
              tooltip-format-disconnected = "MPD (disconnected)";
              on-click = "${_ pkgs.mpc} toggle";
              on-click-middle = "${_ pkgs.mpc} prev";
              on-click-right = "${_ pkgs.mpc} next";
              on-update = "";
              on-scroll-up = "${_ pkgs.mpc} seek +00:00:01";
              on-scroll-down = "${_ pkgs.mpc} seek -00:00:01";
              smooth-scrolling-threshold = 1;
            };
            network = {
              interval = 5;
              "format-alt" = "DOWN: {bandwidthDownBits} UP: {bandwidthUpBits}";
              "format-ethernet" = "󰈀 IP LEAK: {ipaddr}/{cidr}";
              "format-linked" = "{ifname} (No IP)";
              "format-disconnected" = "⚠ Disconnected";
              "format-wifi" = "󰖩 IP LEAK: {ipaddr}/{cidr}";
            };
            pulseaudio = {
              "format" = "{icon} {volume}% {format_source}";
              "format-muted" = "󰝟 {format_source}";
              "format-bluetooth" = "{icon}󰂯 {volume}% {format_source}";
              "format-bluetooth-muted" = "󰝟󰂯 {format_source}";
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
              scroll-step = 5;
              "on-click" = "${_ pkgs.ponymix} -N -t sink toggle";
              "on-click-right" = "${_ pkgs.ponymix} -N -t source toggle";
              smooth-scrolling-threshold = 1;
            };
            idle_inhibitor = {
              format = "{icon}";
              format-icons = {
                activated = "";
                deactivated = "";
              };
              timeout = 30;
            };
            "hyprland/submap" = {
              "format" = "{}";
              "max-length" = 8;
              "tooltip" = false;
            };
            "hyprland/workspaces" = {
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
                # "6" = [ ];
                # "7" = [ ];
                # "8" = [ ];
                # "9" = [ ];
                # "10" = [ ];
              };
            };
            tray = {
              icon-size = 16;
              spacing = 10;
            };
          }
        );

        ".config/waybar/style.css".text = ''
          * {
            font-family:
              "${config.myOptions.fonts.terminal.name} Semibold",
              "${config.myOptions.fonts.icon.name}",
              monospace;
            font-size: ${toString config.myOptions.fonts.size}px;
          }

          window#waybar {
            background-color: #${palette.base00};
            color: #${palette.base05};
            border-bottom: 2px solid #${palette.base01};
            transition-property: background-color;
            transition-duration: 0.5s;
          }

          window#waybar.hidden {
            opacity: 0.5;
          }

          #custom-menu {
            background-color: #${palette.base01};
            color: #${palette.base09};
            font-size: 18px;
            border-radius: 0px 14px 0px 0px;
            margin: 0px 0px 0px 0px;
            padding: 2px 8px 2px 8px;
          }

          #custom-disk_home {
            color: #${palette.base0D};
          }

          #custom-disk_root {
            color: #${palette.base0D};
          }

          #custom-power {
            background-color: #${palette.base08};
            font-size: 16px;
          }

          #custom-power,
          #custom-themes {
            color: #${palette.base00};
            border-radius: 10px;
            margin: 6px 6px 6px 0px;
            padding: 2px 8px 2px 8px;
          }

          #idle_inhibitor {
            background-color: #${palette.base0B};
            color: #${palette.base00};
            border-radius: 10px;
            margin: 6px 0px 6px 6px;
            padding: 4px 6px;
          }

          #idle_inhibitor.deactivated {
            background-color: #${palette.base08};
          }

          #tray {
            background-color: #${palette.base01};
            border-radius: 10px;
            margin: 6px 0px 6px 6px;
            padding: 4px 6px;
          }

          #tray > .passive {
            -gtk-icon-effect: dim;
          }

          #tray > .needs-attention {
            -gtk-icon-effect: highlight;
          }

          #tray > .active {
          }

          @keyframes gradient {
            0% {
              background-position: 0% 50%;
            }

            50% {
              background-position: 100% 50%;
            }

            100% {
              background-position: 0% 50%;
            }
          }

          #mpd {
            color: #${palette.base05};
            font-size: 12px;
            font-weight: bold;
          }

          #mpd.disconnected {
            color: #${palette.base08};
          }

          #mpd.stopped {
            color: #${palette.base08};
          }

          #mpd.playing {
            color: #${palette.base0C};
          }

          #mpd.paused {
          }

          #mpd.2 {
            border-radius: 10px 0px 0px 10px;
            margin: 6px 0px 6px 6px;
            padding: 4px 6px 4px 10px;
          }

          #mpd.3 {
            margin: 6px 0px 6px 0px;
            padding: 4px;
          }

          #mpd.4 {
            border-radius: 0px 10px 10px 0px;
            margin: 6px 6px 6px 0px;
            padding: 4px 10px 4px 6px;
          }

          #mpd.2,
          #mpd.3,
          #mpd.4 {
            background-color: #${palette.base01};
            font-size: 14px;
          }

          #custom-spotify {
            background-color: #${palette.base01};
            color: #${palette.base05};
            border-radius: 10px;
            margin: 6px 0px 6px 6px;
            padding: 4px 8px;
            font-size: 12px;
            font-weight: bold;
          }

          #custom-spotify.paused {
            color: #${palette.base05};
          }

          #custom-spotify.playing {
            background: linear-gradient(
              90deg,
              #${palette.base09} 25%,
              #${palette.base08} 50%,
              #${palette.base0A} 75%,
              #${palette.base0C} 100%
            );
            background-size: 300% 300%;
            animation: gradient 10s ease infinite;
            color: #${palette.base00};
          }

          #custom-spotify.offline {
            color: #${palette.base08};
          }

          #cpu {
            color: #${palette.base08};
          }

          #memory {
            color: #${palette.base0B};
          }

          #disk {
            color: #${palette.base0A};
          }

          #pulseaudio {
            color: #${palette.base0D};
          }

          #pulseaudio.bluetooth {
            color: #${palette.base0C};
          }

          #pulseaudio.muted {
            color: #${palette.base08};
          }

          #pulseaudio.2 {
          }

          #pulseaudio.2.bluetooth {
          }

          #pulseaudio.2.muted {
          }

          #backlight {
            color: #${palette.base09};
          }

          #battery {
            color: #${palette.base0C};
          }

          #battery.charging {
          }

          #battery.plugged {
          }

          @keyframes blink {
            to {
              color: #${palette.base05};
            }
          }

          #battery.critical:not(.charging) {
            background-color: #${palette.base02};
          }

          #battery.2.critical:not(.charging) {
            background-color: #${palette.base01};
            color: #${palette.base08};
            animation-name: blink;
            animation-duration: 0.5s;
            animation-timing-function: linear;
            animation-iteration-count: infinite;
            animation-direction: alternate;
          }

          #bluetooth {
            color: #${palette.base0B};
          }

          #bluetooth.disabled {
            color: #${palette.base08};
          }

          #bluetooth.off {
            color: #${palette.base08};
          }

          #bluetooth.on {
          }

          #bluetooth.connected {
          }

          #bluetooth.discoverable {
          }

          #bluetooth.discovering {
          }

          #bluetooth.pairable {
          }

          #clock {
            color: #${palette.base0D};
          }

          #network {
            color: #${palette.base0E};
          }

          #submap {
            background-color: #${palette.base00};
            color: #${palette.base05};
          }

          #workspaces {
            background-color: #${palette.base00};
            margin: 6px;
            padding: 0px;
          }

          #workspaces button {
            color: #${palette.base05};
            padding: 5px;
            background-color: #${palette.base00};
            border-radius: 10px;
          }

          #workspaces button.empty {
            color: #${palette.base04};
            background-color: #${palette.base00};
          }

          #workspaces button.visible {
            color: #${palette.base04};
          }

          #workspaces button.active {
            color: #${palette.base00};
            background-color: #${palette.base07};
          }

          #workspaces button:hover {
            color: #${palette.base00};
            background-color: #${palette.base0E};
          }

          #backlight,
          #battery,
          #clock,
          #cpu,
          #custom-disk_root,
          #custom-disk_home,
          #disk,
          #memory,
          #pulseaudio,
          #network,
          #bluetooth {
            background-color: #${palette.base02};
            border-radius: 10px 0px 0px 10px;
            margin: 6px 0px 6px 0px;
            padding: 4px 6px;
          }

          #backlight.2,
          #battery.2,
          #clock.2,
          #cpu.2,
          #disk.2,
          #memory.2,
          #pulseaudio.2,
          #network.2,
          #bluetooth.2 {
            background-color: #${palette.base01};
            color: #${palette.base05};
            font-size: 12px;
            font-weight: bold;
            border-radius: 0px 10px 10px 0px;
            margin: 6px 6px 6px 0px;
            padding: 5px 6px 4px 6px;
          }
        '';
      };
    };
  };
}
