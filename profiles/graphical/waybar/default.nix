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
      # package = inputs.hyprland.packages.${pkgs.system}.waybar-hyprland;
      package = pkgs.waybar.overrideAttrs (old: {
        postPatch = ''
          # use hyprctl to switch workspaces
          sed -i 's/zext_workspace_handle_v1_activate(workspace_handle_);/const std::string command = "hyprctl dispatch workspace " + name_;\n\tsystem(command.c_str());/g' src/modules/wlr/workspace_manager.cpp
        '';
        postFixup = ''
          wrapProgram $out/bin/waybar \
            --suffix PATH : ${lib.makeBinPath [inputs.hyprland.packages.${pkgs.system}.hyprland]}
        '';
        mesonFlags = old.mesonFlags ++ ["-Dexperimental=true"];
      });
      settings = {
        mainBar = {
          position = "bottom";
          monitor = "eDP-1";
          # layer = "top";
          height = 25;
          # mode = "dock";
          # width = "";
          # spacing = 6;
          # margin = "0";
          # margin-top = 0;
          # margin-bottom = 0;
          # margin-left = 0;
          # margin-right = 0;
          # fixed-center = true;
          # ipc = true;

          modules-left = [
            "wlr/workspaces"
            "tray"
          ];
          modules-right = [
            "network"
            "custom/wireguard"
            "custom/teavpn"
            "pulseaudio"
            "battery"
            "custom/date"
            "clock"
          ];
          "pulseaudio" = {
            "format" = "{icon} {volume}%";
            "format-muted" = "󰝟";
            "on-click" = "amixer -q set Master toggle-mute";
            "format-icons" = ["" "" ""];
          };
          "cpu" = {
            "interval" = 10;
            "format" = " {}%";
            "max-length" = 10;
          };
          "memory" = {
            "interval" = 30;
            "format" = " {}%";
            "max-length" = 10;
          };
          "wlr/workspaces" = {
            on-click = "activate";
            active-only = false;
            disable-scroll = true;
            all-outputs = true;
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
              # "active" = "";
              "default" = "";
            };
          };
          "sway/workspaces" = {
            on-click = "activate";
            active-only = false;
            disable-scroll = true;
            all-outputs = true;
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
              # "active" = "";
              "default" = "";
            };
          };
          "tray" = {
            spacing = 5;
          };
          "network" = {
            interface = "wlp4s0";
            format-wifi = " Connected";
            format-linked = "{ifname} (No IP)";
            format-disconnected = "󰖪 Disconnected";
            tooltip-format-wifi = "Signal Strenght: {signalStrength}% | Down Speed: {bandwidthDownBits}, Up Speed: {bandwidthUpBits}";
          };
          "custom/wireguard" = {
            "format" = " Wireguard";
            "exec" = "echo '{\"class\": \"connected\"}'";
            "exec-if" = "test -d /proc/sys/net/ipv4/conf/wg0";
            "return-type" = "json";
            "interval" = 5;
          };
          "custom/teavpn" = {
            "format" = " TeaVPN";
            "exec" = "echo '{\"class\": \"connected\"}'";
            "exec-if" = "test -d /proc/sys/net/ipv4/conf/teavpn2-cl-01";
            "return-type" = "json";
            "interval" = 5;
          };
          "battery" = {
            bat = "BAT1";
            interval = 60;
            format = "{icon}{capacity}%";
            format-charging = "󰂄 {capacity}%";
            states = {
              "good" = 95;
              "warning" = 20;
              "critical" = 10;
            };
            format-icons = [
              " "
              " "
              ""
              " "
              " "
            ];
          };
          "custom/date" = {
            format = " {}";
            interval = 3600;
            exec = "${lib.getExe waybar-date}";
          };
          "clock" = {
            format = " {:%I:%M %p}";
            tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
          };
        };
      };
      style = import ./style.nix args;
    };
  };
}
