{
  lib,
  pkgs,
  config,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf getExe;
  _ = getExe;

  cfg = config.mine.waybar;

  # Custom script for date with Japanese/English formatting
  waybar-date = pkgs.writeShellScriptBin "waybar-date" ''
    ja=$(LC_TIME=ja_JP.UTF-8 date "+%A, %Y年 %-m月 %-d日")
    en=$(LC_TIME=en_US.UTF-8 date "+%A, %B %-d, %Y")
    printf '{"text":"| DATE: %s ","tooltip":"%s"}\n' "$ja" "$en"
  '';

  # The Waybar configuration set
  waybarSettings = {
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
      "niri/workspaces"
      # "dwl/tags"
      "ext/workspaces"
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
      artist-len = 8;
      title-len = 12;
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
      format-wifi = "| NET: DOWN {bandwidthDownBits} UP {bandwidthUpBits}";
      format-ethernet = "| IP LEAK: {ipaddr}/{cidr}";
      format-linked = "| IP LEAK: (No IP)";
      format-disconnected = "| NET: DISCONNECTED";
      format-alt = "| IP LEAK: {ipaddr}/{cidr}";
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

    "niri/workspaces" = {
      format = "{value}";
      on-click = "activate";
      tooltip = false;
    };

    "dwl/tags" = {
      num-tags = 9;
      disable-click = false;
    };

    "ext/workspaces" = {
      format = "{name}";
      sort-by-number = true;
      on-click = "activate";
    };

    "hyprland/workspaces" = {
      format = "{icon}";
      on-click = "activate";
      on-scroll-up = "${config.mine.hyprland.package}/bin/hyprctl dispatch workspace e-1";
      on-scroll-down = "${config.mine.hyprland.package}/bin/hyprctl dispatch workspace e+1";
    };

    tray = {
      icon-size = 16;
      spacing = 10;
    };
  };
in
{
  imports = [ ./_style.nix ];
  options.mine.waybar = {
    enable = mkEnableOption "waybar";
  };

  config = mkIf cfg.enable {
    hj = {
      packages = [ pkgs.waybar ];
      xdg.config.files."waybar/config.jsonc" = {
        generator = lib.generators.toJSON { };
        value = waybarSettings;
      };
    };
  };
}
