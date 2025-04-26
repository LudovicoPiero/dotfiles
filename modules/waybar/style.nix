{ config, osConfig, ... }:
let
  inherit (config.colorScheme) palette;
in
{
  programs.waybar.style = ''
    @define-color background #1E1E2E;
    @define-color background-alt1 #28283d;
    @define-color background-alt2 #32324d;
    @define-color foreground #CDD6F4;
    @define-color selected #89B4FA;
    @define-color black #45475A;
    @define-color red #F38BA8;
    @define-color green #A6E3A1;
    @define-color yellow #F9E2AF;
    @define-color blue #89B4FA;
    @define-color magenta #F5C2E7;
    @define-color cyan #94E2D5;
    @define-color white #BAC2DE;

    * {
      font-family:
        "${osConfig.myOptions.fonts.main.name} Semibold",
        "${osConfig.myOptions.fonts.icon.name}",
        monospace;
      font-size: ${toString osConfig.myOptions.fonts.size}px;
    }

    window#waybar {
     background-color: @background;
     color: @background;
     border-bottom: 0px solid @background-alt1;
     border-radius: 0px 0px 20px 20px;
     transition-property: background-color;
     transition-duration: .5s;
    }

    window#waybar.hidden {
     opacity: 0.5;
    }

    #backlight {
     background-color: @green;
    }

    #battery {
     background-color: @blue;
    }

    #battery.charging {}

    #battery.plugged {}

    @keyframes blink {
     to {
      color: @black;
     }
    }

    #battery.critical:not(.charging) {
     background-color: @red;
     color: @red;
     animation-name: blink;
     animation-duration: 0.5s;
     animation-timing-function: linear;
     animation-iteration-count: infinite;
     animation-direction: alternate;
    }

    #clock {
     background-color: @yellow;
    }

    #cpu {
     background-color: @cyan;
    }

    #memory {
     background-color: @magenta;
    }

    #idle_inhibitor {
     background-color: @green;
    }

    #idle_inhibitor.deactivated {
     background-color: @red;
    }

    #tray {
     background-color: @background-alt2;
    }

    #tray>.passive {
     -gtk-icon-effect: dim;
    }

    #tray>.needs-attention {
     -gtk-icon-effect: highlight;
    }

    #tray>.active {}

    #pulseaudio {
     background-color: @yellow;
    }

    #pulseaudio.bluetooth {
     background-color: @yellow;
    }

    #pulseaudio.muted {
     background-color: @red;
     color: @background;
    }

    #network {
     background-color: @magenta;
    }

    #network.disconnected,
    #network.disabled {
     background-color: @background-alt1;
     color: @foreground;
    }

    #network.linked {}

    #network.ethernet {}

    #network.wifi {}

    #bluetooth {
     background-color: @cyan;
    }

    #bluetooth.disabled {
     background-color: @background-alt1;
     color: @foreground;
    }

    #bluetooth.off {
     background-color: @background-alt1;
     color: @foreground;
    }

    #bluetooth.on {}

    #bluetooth.connected {}

    #bluetooth.discoverable {}

    #bluetooth.discovering {}

    #bluetooth.pairable {}

    #workspaces {
     background-color: @background;
     border-radius: 4px;
     margin: 0px 0px;
     padding: 0px 0px;
    }

    #workspaces button {
     color: @foreground;
    }

    #workspaces button.active {
     color: @selected;
    }

    #workspaces button.urgent {
     color: @red;
    }

    #workspaces button.hidden {
     color: @yellow;
    }

    #custom-themes,
    #custom-menu,
    #custom-power,
    #custom-disk_home,
    #custom-disk_root {
     border-radius: 12px;
     margin: 6px 0px;
     padding: 2px 10px;
    }

    #custom-disk_root {
     background-color: @selected;
    }
    #custom-disk_home {
     background-color: @selected;
    }

    #custom-themes {
     background-color: @selected;
     padding: 2px 8px;
    }

    #custom-menu {
     background-color: @selected;
     margin-left: 6px;
     padding: 2px 6px;
     font-size: 16px;
    }

    #custom-power {
     background-color: @red;
     margin-right: 6px;
     padding: 2px 8px;
     font-size: 16px;
    }

    #backlight,
    #battery,
    #clock,
    #cpu,
    #mode,
    #memory,
    #mpd,
    #custom-disk_root,
    #custom-disk_home,
    #idle_inhibitor,
    #tray,
    #pulseaudio,
    #network,
    #bluetooth {
     border-radius: 12px;
     margin: 6px 0px;
     padding: 2px 10px;
    }
  '';
}
