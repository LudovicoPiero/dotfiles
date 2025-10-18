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
    printf '{"text":"| DATE: %s ","tooltip":"%s"}\n' "$ja" "$en"
  '';

  cfg = config.mine.waybar;
in
{
  imports = [ ./style.nix ];

  options.mine.waybar = {
    enable = mkEnableOption "waybar service";
  };

  config = mkIf cfg.enable {
    hm.programs.waybar = {
      enable = true;
      settings.main = {
        layer = "top";
        position = "bottom";
        height = 32;
        spacing = 6;
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
        };

        "custom/tailscale" = {
          format = "| TAILSCALE";
          exec = "ip link show tailscale0 >/dev/null 2>&1 && echo '{\"class\": \"connected\"}' || echo '{}'";
          return-type = "json";
          interval = 5;
        };

        "custom/wireguard" = {
          format = "| WIREGUARD";
          exec = "echo '{\"class\": \"connected\"}'";
          exec-if = "test -d /proc/sys/net/ipv4/conf/wg0";
          return-type = "json";
          interval = 5;
        };

        backlight = {
          interval = 2;
          format = "| BACKLIGHT: {percent}%";
          on-scroll-up = "${_ pkgs.light} -A 5%";
          on-scroll-down = "${_ pkgs.light} -U 5%";
        };

        battery = {
          interval = 60;
          format = "| BAT: {capacity}%";
          format-charging = "| BAT+: {capacity}%";
          format-plugged = "| BAT(AC): {capacity}%";
          format-full = "| BAT: FULL";
          format-alt = "| BAT: {time}";
          tooltip = true;
        };

        bluetooth = {
          format = "| BT {status}";
          format-on = "| BT {status}";
          format-off = "| BT OFF";
          format-disabled = "| BT DIS";
          format-connected = "| BT {device_alias}";
          format-connected-battery = "| BT {device_battery_percentage}%";
          tooltip = true;
        };

        clock = {
          format = "| TIME: {:%I:%M %p}";
          tooltip-format = "\n<span size='9pt' font='${config.mine.fonts.main.name}'>{calendar}</span>";
          calendar = {
            mode = "year";
            format = {
              months = "<span color='#ffead3'><b>{}</b></span>";
              days = "<span color='#ecc6d9'><b>{}</b></span>";
              weeks = "<span color='#99ffdd'><b>W{}</b></span>";
              weekdays = "<span color='#ffcc66'><b>{}</b></span>";
              today = "<span color='#ff6699'><b><u>{}</u></b></span>";
            };
          };
        };

        "custom/date" = {
          return-type = "json";
          interval = 3600;
          exec = "${_ waybar-date}";
        };

        cpu = {
          interval = 5;
          format = "| CPU: {usage}%";
        };

        "custom/menu" = {
          format = "MENU";
          tooltip = false;
          on-click = "${_ pkgs.fuzzel}";
        };

        "custom/power" = {
          format = "POWER";
          tooltip = false;
          on-click = "${_ pkgs.wleave}";
        };

        "custom/disk_home" = {
          format = "| HOME: {}";
          tooltip-format = "Size of /home";
          interval = 30;
          exec = "df -h --output=avail /dev/disk/by-label/HOME | tail -1 | tr -d ' '";
        };

        "custom/disk_root" = {
          format = "| ROOT: {}";
          tooltip-format = "Size of /";
          interval = 30;
          exec = "df -h --output=avail / | tail -1 | tr -d ' '";
        };

        memory = {
          interval = 10;
          format = "| MEM: {used:0.1f}G";
        };

        mpd = {
          interval = 2;
          format = "| MPD: {stateIcon} {artist} - {title}";
          format-disconnected = "| MPD DISCONNECTED";
          format-paused = "| MPD PAUSED: {artist} - {title}";
          format-stopped = "| MPD STOPPED";
          state-icons = {
            paused = "PAUSE";
            playing = "PLAY";
          };
          tooltip-format = "MPD (connected)";
          tooltip-format-disconnected = "MPD (disconnected)";
          on-click = "${_ pkgs.mpc} toggle";
          on-click-middle = "${_ pkgs.mpc} prev";
          on-click-right = "${_ pkgs.mpc} next";
          on-scroll-up = "${_ pkgs.mpc} seek +00:00:01";
          on-scroll-down = "${_ pkgs.mpc} seek -00:00:01";
        };

        network = {
          interval = 5;
          format-alt = "| NET: DOWN {bandwidthDownBits} UP {bandwidthUpBits}";
          format-ethernet = "| NET: {ipaddr}/{cidr}";
          format-linked = "| NET: (No IP)";
          format-disconnected = "| NET: DISCONNECTED";
          format-wifi = "| NET: {ipaddr}/{cidr}";
        };

        pulseaudio = {
          format = "| VOL: {volume}% {format_source}";
          format-muted = "| VOL: MUTE {format_source}";
          format-bluetooth = "| VOL: BT {volume}% {format_source}";
          format-bluetooth-muted = "| VOL: BT MUTE {format_source}";
          format-source = "MIC: {volume}%";
          format-source-muted = "MIC: MUTE";
          scroll-step = 5;
          on-click = "${_ pkgs.ponymix} -N -t sink toggle";
          on-click-right = "${_ pkgs.ponymix} -N -t source toggle";
        };

        idle_inhibitor = {
          format = "| {icon}";
          format-icons = {
            activated = "INHIBIT ON";
            deactivated = "INHIBIT OFF";
          };
        };

        "hyprland/submap" = {
          format = "| {}";
          max-length = 8;
          tooltip = false;
        };

        "hyprland/workspaces" = {
          format = "{icon}";
          on-click = "activate";
          on-scroll-up = "hyprctl dispatch workspace e-1";
          on-scroll-down = "hyprctl dispatch workspace e+1";
        };

        tray = {
          icon-size = 16;
          spacing = 10;
        };
      };
    };
  };
}
