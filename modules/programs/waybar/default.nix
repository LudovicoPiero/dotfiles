{
  lib,
  pkgs,
  config,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;

  _ = lib.getExe;

  waybar-date = pkgs.writeShellScriptBin "waybar-date" ''
    ja=$(LC_TIME=ja_JP.UTF-8 date "+%A, %Y年 %-m月 %-d日")
    en=$(LC_TIME=en_US.UTF-8 date "+%A, %B %-d, %Y")
    printf '{"text":"  %s","tooltip":"%s"}\n' "$ja" "$en"
  '';

  cfg = config.mine.waybar;
in
{
  imports = [ ./style.nix ];
  options.mine.waybar = {
    enable = mkEnableOption "waybar service";
  };

  config = mkIf cfg.enable {
    hm = {
      programs.waybar = {
        enable = true;
        settings.main = {
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
            "hyprland/workspaces"
            "sway/workspaces"
          ];
          modules-center = [ "hyprland/submap" ];
          modules-right = [
            "tray"
            "idle_inhibitor"
            # "cpu"
            # "custom/disk_home"
            # "custom/disk_root"
            # "custom/wireguard"
            # "custom/tailscale"
            "mpd"
            "pulseaudio"
            "bluetooth"
            "network"
            "battery"
            "clock"
            "custom/date"
            "custom/power"
          ];
          "sway/workspaces" = {
            format = "{name}";
            all-outputs = true;
            disable-scroll = false;
            # persistent-workspaces = {
            #   "1" = [ ];
            #   "2" = [ ];
            #   "3" = [ ];
            #   "4" = [ ];
            #   "5" = [ ];
            # };
          };
          "custom/tailscale" = {
            "format" = "󰖂 Tailscale";
            "exec" =
              "ip link show tailscale0 >/dev/null 2>&1 && echo '{\"class\": \"connected\"}' || echo '{}'";
            "return-type" = "json";
            "interval" = 5;
          };
          "custom/wireguard" = {
            "format" = "󰖂 Wireguard";
            "exec" = "echo '{\"class\": \"connected\"}'";
            "exec-if" = "test -d /proc/sys/net/ipv4/conf/wg0";
            "return-type" = "json";
            "interval" = 5;

          };
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
            format-connected-battery = "󰂯{device_battery_percentage}%";
            tooltip = true;
            tooltip-format = "{controller_alias}\t{controller_address}";
            tooltip-format-connected = "{controller_alias}\t{controller_address}\n\n{device_enumerate}";
            tooltip-format-enumerate-connected = "{device_alias}\t{device_address}";
          };
          "clock" = {
            "format" = " {:%I:%M %p}";
            "tooltip-format" = "\n<span size='9pt' font='${config.mine.fonts.main.name}'>{calendar}</span>";
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
          "custom/date" = {
            "return-type" = "json";
            "interval" = 3600;
            "exec" = "${_ waybar-date}";
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
            on-click = "${_ pkgs.wleave}";
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
        };
      };
    };
  };
}
