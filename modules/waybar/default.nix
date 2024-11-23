{
  lib,
  pkgs,
  config,
  inputs,
  ...
}: let
  inherit
    (lib)
    mkEnableOption
    mkIf
    ;

  _ = lib.getExe;

  waybar-date = pkgs.writeShellScriptBin "waybar-date" ''
    date "+%a %d %b %Y"
  '';

  cfg = config.myOptions.waybar;
in {
  options.myOptions.waybar = {
    enable =
      mkEnableOption "waybar"
      // {
        default = config.myOptions.hyprland.enable;
      };
  };

  config = mkIf cfg.enable {
    home-manager.users.${config.myOptions.vars.username} = {
      config,
      osConfig,
      ...
    }: {
      home.packages = with pkgs; [alsa-utils];

      programs.waybar = {
        enable = true;
        style = import ./style.nix {inherit osConfig config;};

        # package = pkgs.waybar;
        package = inputs.ludovico-nixpkgs.packages.${pkgs.stdenv.hostPlatform.system}.waybar;

        settings = {
          # Thanks to https://gist.github.com/genofire/07234e810fcd16f9077710d4303f9a9e
          mainBar = {
            "layer" = "top"; # Waybar at top layer
            "position" = "bottom"; # Waybar position (top|bottom|left|right)
            "height" = 18; # Waybar height (to be removed for auto height)

            # Choose the order of the modules
            "modules-left" = [
              "hyprland/workspaces"
              "custom/separator"
              "custom/wireguard"
              "custom/teavpn"
            ];
            "modules-right" = [
              "custom/disk_home"
              "custom/separator"
              "custom/disk_root"
              "custom/separator"
              # "cpu"
              # "custom/separator"
              # "memory"
              # "custom/separator"
              "network"
              "custom/separator"
              "pulseaudio"
              "custom/separator"
              "clock"
              "custom/separator"
              "custom/date"
              "custom/separator"
              "battery"
              "custom/separator"
              "idle_inhibitor"
              "custom/separator"
              "tray"
            ];

            # Modules configuration

            "hyprland/workspaces" = {
              "active-only" = false;
              "all-outputs" = true;
              "format" = "{icon}";
              "show-special" = false;
              "on-click" = "activate";
              "on-scroll-up" = "hyprctl dispatch workspace e-1";
              "on-scroll-down" = "hyprctl dispatch workspace e+1";
              "persistent-workspaces" = {
                "1" = [];
                "2" = [];
                "3" = [];
                "4" = [];
                "5" = [];
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

            "custom/wireguard" = {
              "format" = "󰖂 Wireguard";
              "exec" = "echo '{\"class\": \"connected\"}'";
              "exec-if" = "test -d /proc/sys/net/ipv4/conf/wg0";
              "return-type" = "json";
              "interval" = 5;
            };

            "custom/teavpn" = {
              "format" = "󰖂 Teavpn";
              "exec" = "echo '{\"class\": \"connected\"}'";
              "exec-if" = "test -d /proc/sys/net/ipv4/conf/teavpn2-cl-01";
              "return-type" = "json";
              "interval" = 5;
            };

            "custom/separator" = {
              "format" = "|";
              "tooltip" = false;
            };

            "custom/disk_home" = {
              "format" = "󰋊 Porn Folder: {}";
              "interval" = 30;
              "exec" = "df -h --output=avail /dev/disk/by-label/HOME | tail -1 | tr -d ' '";
            };

            "custom/disk_root" = {
              "format" = "󰋊 Hentai Folder: {}";
              "interval" = 30;
              "exec" = "df -h --output=avail / | tail -1 | tr -d ' '";
            };

            "cpu" = {
              "format" = "󰻠 {usage}%";
              "tooltip" = false;
            };

            "memory" = {
              "format" = "󰍛 {used:0.1f}G";
            };

            "network" = {
              "format-wifi" = "DOWN: {bandwidthDownBits} UP: {bandwidthUpBits}";
              "format-ethernet" = "󰈀 IP Leaked: {ipaddr}/{cidr}";
              "format-linked" = "{ifname} (No IP)";
              "format-disconnected" = "Disconnected ⚠";
              "format-alt" = "{ifname}: {ipaddr}/{cidr}";
              "interval" = 5;
            };

            "pulseaudio" = {
              "format" = "{icon} {volume}% {format_source}";
              "format-muted" = "󰖁 {format_source}";
              "format-bluetooth" = "{icon}󰂯 {volume}% {format_source}";
              "format-bluetooth-muted" = "󰖁󰂯 {format_source}";

              "format-source" = "󰍬 {volume}%";
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
              "on-click" = "${_ pkgs.ponymix} -N -t sink toggle";
              "on-click-right" = "${_ pkgs.ponymix} -N -t source toggle";
            };

            "clock" = {
              "interval" = 1;
              "format" = "󰅐 {:%I:%M %p}";
              "tooltip-format" = "{:%Y-%m-%d | %H:%M:%S}";
            };

            "custom/date" = {
              format = "󰸗 {}";
              interval = 3600;
              exec = "${lib.getExe waybar-date}";
            };

            "battery" = {
              "states" = {
                # "good"= 95;
                "warning" = 20;
                "critical" = 10;
              };
              "format" = "<span color='#e88939'>{icon}</span> {capacity}%";
              "format-charging" = "<span color='#e88939'>󰂄</span> {capacity}%";
              "format-plugged" = "<span color='#e88939'>{icon} </span> {capacity}% ({time})";
              "format-icons" = [
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

            "idle_inhibitor" = {
              "format" = "<span color='#589df6'>{icon}</span>";
              "format-icons" = {
                "activated" = "󰈈";
                "deactivated" = "󰈉";
              };
              "on-click-right" = "hyprlock";
            };

            "tray" = {
              # "icon-size"= 21;
              "spacing" = 10;
            };
          };
        };
      };
    }; # For Home-Manager options
  };
}
