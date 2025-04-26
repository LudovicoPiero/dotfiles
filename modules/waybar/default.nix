{
  lib,
  pkgs,
  config,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;

  _ = lib.getExe;

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

        settings = {
          mainBar = {
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
              format = "󰂯 {status}";
              format-on = "󰂯 {status}";
              format-off = "󰂲 {status}";
              format-disabled = "󰂲 {status}";
              format-connected = "󰂯 {device_alias}";
              format-connected-battery = "󰂯 {device_alias}, {device_battery_percentage}%";
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
              "format-ethernet" = "󰈀IP LEAK: {ipaddr}/{cidr}";
              "format-linked" = "{ifname} (No IP)";
              "format-disconnected" = "⚠ Disconnected";
              "format-wifi" = "󰖩IP LEAK: {ipaddr}/{cidr}";
            };
            pulseaudio = {
              format = "{icon} {volume}%";
              format-muted = " Mute";
              format-bluetooth = " {volume}% {format_source}";
              format-bluetooth-muted = " Mute";
              format-source = " {volume}%";
              format-source-muted = "";
              format-icons = {
                headphone = "";
                phone = "";
                portable = "";
                car = "";
                default = [
                  ""
                  ""
                  ""
                ];
              };
              scroll-step = 5;
              on-click = "${_ pkgs.pulsemixer} --toggle-mute";
              on-click-right = "${_ pkgs.pulsemixer} --toggle-mute";
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
          };
        };
      };
    };
  };
}
