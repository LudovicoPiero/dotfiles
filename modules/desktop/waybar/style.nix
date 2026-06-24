{
  config,
  lib,
  ...
}:
let
  inherit (lib) mkIf;
  cfg = config.mine.mango;
in
{
  config = mkIf cfg.enable {
    hj = {
      xdg.config.files."waybar/style.css".text = ''
        @define-color color-bg                                  #1b1a1a;
        @define-color color-fg                                  #ebdbb2;
        @define-color color-button-bg                           #83a598;
        @define-color color-button-fg                           #1b1a1a;
        @define-color color-button-urgent-bg                    #fb4934;
        @define-color color-button-urgent-fg                    #1b1a1a;
        @define-color color-workspace-button-bg                 #504945;
        @define-color color-workspace-button-fg                 #ebdbb2;
        @define-color color-workspace-button-hover-bg           #665c54;
        @define-color color-workspace-button-hover-fg           #ebdbb2;
        @define-color color-workspace-button-focused-bg         #83a598;
        @define-color color-workspace-button-focused-fg         #1b1a1a;
        @define-color color-taskbar-button-minimized-bg         #bd788a;
        @define-color color-taskbar-button-minimized-fg         #1b1a1a;
        @define-color color-taskbar-button-active-bg            #BABD2C;
        @define-color color-taskbar-button-active-fg            #1b1a1a;
        @define-color color-widget-audio-bg                     #e3ac2b;
        @define-color color-widget-audio-fg                     #1b1a1a;
        @define-color color-widget-audio-hover-bg               #e3ac2b;
        @define-color color-widget-audio-hover-fg               #1b1a1a;
        @define-color color-widget-audio-muted-bg               #e3ac2b;
        @define-color color-widget-audio-muted-fg               #1b1a1a;
        @define-color color-widget-clock-bg                     #d5c4a1;
        @define-color color-widget-clock-fg                     #1b1a1a;
        @define-color color-widget-battery-bg                   #b8bb26;
        @define-color color-widget-battery-fg                   #1b1a1a;
        @define-color color-widget-battery-low-bg               #df402f;
        @define-color color-widget-battery-low-fg               #1b1a1a;
        @define-color color-widget-battery-low-blink-bg         #df402f;
        @define-color color-widget-battery-low-blink-fg         #1b1a1a;
        @define-color color-widget-backlight-bg                 #d3869b;
        @define-color color-widget-backlight-fg                 #1b1a1a;
        @define-color color-widget-temperature-bg               #8ec07c;
        @define-color color-widget-temperature-fg               #1b1a1a;
        @define-color color-widget-temperature-critical-bg      #df402f;
        @define-color color-widget-temperature-critical-fg      #1b1a1a;
        @define-color color-widget-memory-bg                    #83a598;
        @define-color color-widget-memory-fg                    #1b1a1a;
        @define-color color-widget-cpu-bg                       #d5c4a1;
        @define-color color-widget-cpu-fg                       #1b1a1a;
        @define-color color-widget-power-profile-balanced-bg    #d3869b;
        @define-color color-widget-power-profile-balanced-fg    #1b1a1a;
        @define-color color-widget-power-profile-performance-bg #fe8019;
        @define-color color-widget-power-profile-performance-fg #1b1a1a;
        @define-color color-widget-power-profile-saver-bg       #b8bb26;
        @define-color color-widget-power-profile-saver-fg       #1b1a1a;
        @define-color color-widget-network-bg                   #b8bb26;
        @define-color color-widget-network-fg                    #1b1a1a;
        @define-color color-widget-tray-bg                      #504945;
        @define-color color-widget-tray-needs-attention         #fb4934;
        @define-color color-widget-custom-notification-bg        #504945;
        @define-color color-widget-custom-notification-fg        #dfcdb3;
        @define-color color-widget-scratchpad-bg                #ff0000;
        @define-color color-widget-scratchpad-fg                #ff0000;
        @define-color color-widget-power-bg                     #83a598;
        @define-color color-widget-power-fg                     #1b1a1a;
        @define-color color-widget-window-bg                    #bd788a;
        @define-color color-widget-window-fg                    #111111;
        @define-color color-widget-keyboard-state-bg            #fe8019;
        @define-color color-widget-keyboard-state-fg            #1b1a1a;
        @define-color color-widget-language-bg                  #fe8019;
        @define-color color-widget-language-fg                  #1b1a1a;
        @define-color color-tooltip-bg                          #241F19;
        @define-color color-tooltip-fg                          #ebdbb2;
        @define-color color-menu-bg                             #241F19;
        @define-color color-menuitem-bg                         #241F19;
        @define-color color-menuitem-fg                         #ebdbb2;
        @define-color color-menuitem-hover-bg                   #b8bb26;
        @define-color color-menuitem-hover-fg                   #1b1a1a;
        @define-color color-menuitem-active-bg                  #ebdbb2;
        @define-color color-menuitem-active-fg                  #1b1a1a;
        @define-color color-gradient-fade                       #fbf1c7;

        * {
            font-family: "JetBrains Mono", monospace;
            font-size: 20px;
            font-weight: bold;
            border: none;
            border-radius: 100px;
        }

        window#waybar {
            background: none;
            border: none;
            margin: 10px;
        }

        window#waybar > * {
            margin: 10px;
            margin-bottom: 0px;
        }

        window#waybar.hidden {
            opacity: 0.2;
        }

        button {
            border: none;
            background-color: @color-button-bg;
        }

        button:hover {
            background: inherit;
        }

        #pulseaudio:hover {
            background-color: @color-widget-audio-hover-bg;
            color: @color-widget-audio-hover-fg;
        }

        #workspaces {
            padding: 0;
            margin: 0;
        }

        #workspaces button {
            transition: none;
            padding: 0;
            min-height: 0px;
            min-width: 37px;
            margin-left: 4px;
            background: linear-gradient(to top, @color-workspace-button-bg, mix(@color-workspace-button-bg, @color-gradient-fade, 0.25));
            color: @color-workspace-button-fg;
        }

        #workspaces button:hover {
            background: linear-gradient(to top, @color-workspace-button-hover-bg, mix(@color-workspace-button-hover-bg, @color-gradient-fade, 0.25));
            color: @color-workspace-button-hover-fg;
        }

        #workspaces button.active {
            background: linear-gradient(to top, @color-workspace-button-focused-bg, mix(@color-workspace-button-focused-bg, @color-gradient-fade, 0.25));
            color: @color-workspace-button-focused-fg;
        }

        #workspaces button.urgent {
            background: linear-gradient(to top, @color-button-urgent-bg, mix(@color-button-urgent-bg, @color-gradient-fade, 0.25));
            color: @color-button-urgent-fg;
        }

        #taskbar {
            padding: 0px;
            margin-left: 10px;
            margin-right: 10px;
        }

        #taskbar.empty {
          margin-left: 0px;
          margin-right: 0px;
          padding-left: 0px;
          padding-right: 0px;
          border-radius: 0px;
          border-color: transparent;
          border: none;
          background-color: transparent;
        }

        #taskbar button {
            padding-left: 8px;
            min-width: 22px;
            background: linear-gradient(to top, @color-workspace-button-bg, mix(@color-workspace-button-bg, @color-gradient-fade, 0.25));
            color: @color-workspace-button-fg;
        }

        #taskbar button.active  {
            background: linear-gradient(to top, @color-taskbar-button-active-bg, mix(@color-taskbar-button-active-bg, @color-gradient-fade, 0.25));
            color: @color-taskbar-button-active-fg;
        }

        #taskbar button.minimized  {
            background: linear-gradient(to top, @color-taskbar-button-minimized-bg, mix(@color-taskbar-button-minimized-bg, @color-gradient-fade, 0.25));
            color: @color-taskbar-button-minimized-fg;
        }


        #taskbar button.urgent{
            background: linear-gradient(to top, @color-button-urgent-bg, mix(@color-button-urgent-bg, @color-gradient-fade, 0.25));
            color: @color-button-urgent-fg;
        }

        #mode {
            background-color: #ff0000;
            box-shadow: inset 0 -3px #0000ff;
        }

        #clock,
        #battery,
        #cpu,
        #memory,
        #disk,
        #temperature,
        #backlight,
        #network,
        #pulseaudio,
        #wireplumber,
        #custom-media,
        #tray,
        #mode,
        #idle_inhibitor,
        #scratchpad,
        #power-profiles-daemon,
        #custom-notification,
        #custom-power,
        #keyboard-state,
        #language,
        #window,
        #mpd {
            padding: 0px 12px;
        }

        #custom-power {
            margin-left: 10px;
        }

        #window,
        #workspaces {
            margin: 0px 0px;
        }

        #window {
            margin-left: 0px;
        }

        /* If workspaces is the leftmost module, omit left margin */
        .modules-left > widget:first-child > #workspaces {
            margin-left: 0;
        }

        /* If workspaces is the rightmost module, omit right margin */
        .modules-right > widget:last-child > #workspaces {
            margin-right: 0;
        }

        #custom-power {
            background: linear-gradient(to top, @color-widget-power-bg, mix(@color-widget-power-bg, @color-gradient-fade, 0.25));
            color: @color-widget-power-fg;
            font-family: "JetBrains Mono", monospace;
            font-size: 20px;
            font-weight: bold;
        }

        #window {
            background: linear-gradient(to top, @color-widget-window-bg, mix(@color-widget-window-bg, @color-gradient-fade, 0.25));
            color: @color-widget-window-fg;
        }

        window#waybar.empty #window {
            background: none;
            margin: 0px;
            padding: 0px;
        }

        #clock {
            background: linear-gradient(to top, @color-widget-clock-bg, mix(@color-widget-clock-bg, @color-gradient-fade, 0.25));
            color: @color-widget-clock-fg;
        }

        #battery {
            background: linear-gradient(to top, @color-widget-battery-bg, mix(@color-widget-battery-bg, @color-gradient-fade, 0.25));
            color: @color-widget-battery-fg;
        }

        #battery.charging, #battery.plugged {
            background: linear-gradient(to top, @color-widget-battery-bg, mix(@color-widget-battery-bg, @color-gradient-fade, 0.25));
            color: @color-widget-battery-fg;
        }

        #battery.charging {
        }

        @keyframes blink-battery-low {
            to {
                background: linear-gradient(to top, @color-widget-battery-low-blink-bg, mix(@color-widget-battery-low-blink-bg, @color-gradient-fade, 0.25));
                color: @color-widget-battery-low-blink-fg;
            }
        }

        #battery:not(.charging) {
        }

        /* Using steps() instead of linear as a timing function to limit cpu usage */
        #battery.critical:not(.charging) {
            background: linear-gradient(to top, @color-widget-battery-low-bg, mix(@color-widget-battery-low-bg, @color-gradient-fade, 0.25));
            color: @color-widget-battery-low-fg;
            animation-name: blink-battery-low;
            animation-duration: 0.5s;
            animation-timing-function: steps(12);
            animation-iteration-count: infinite;
            animation-direction: alternate;
        }

        #power-profiles-daemon {
        }

        #power-profiles-daemon.performance {
            background: linear-gradient(to top, @color-widget-power-profile-performance-bg, mix(@color-widget-power-profile-performance-bg, @color-gradient-fade, 0.25));
            color: @color-widget-power-profile-performance-fg;
        }

        #power-profiles-daemon.balanced {
            background: linear-gradient(to top, @color-widget-power-profile-balanced-bg, mix(@color-widget-power-profile-balanced-bg, @color-gradient-fade, 0.25));
            color: @color-widget-power-profile-balanced-fg;
        }

        #power-profiles-daemon.power-saver {
            background: linear-gradient(to top, @color-widget-power-profile-saver-bg, mix(@color-widget-power-profile-saver-bg, @color-gradient-fade, 0.25));
            color: @color-widget-power-profile-saver-fg;
        }

        label:focus {
            background-color: #ff0000;
        }

        #cpu {
            min-width: 60px;
            background: linear-gradient(to top, @color-widget-cpu-bg, mix(@color-widget-cpu-bg, @color-gradient-fade, 0.25));
            color: @color-widget-cpu-fg;
        }

        #memory {
            background: linear-gradient(to top, @color-widget-memory-bg, mix(@color-widget-memory-bg, @color-gradient-fade, 0.25));
            color: @color-widget-memory-fg;
        }

        #disk {
            background-color: #ff0000;
        }

        #backlight {
            background: linear-gradient(to top, @color-widget-backlight-bg, mix(@color-widget-backlight-bg, @color-gradient-fade, 0.25));
            color: @color-widget-backlight-fg;
        }

        #network {
            background-color: #ff0000;
        }

        #network.disconnected {
            background-color: #ff0000;
        }

        #pulseaudio {
            background: linear-gradient(to top, @color-widget-audio-bg, mix(@color-widget-audio-bg, @color-gradient-fade, 0.25));
            color: @color-widget-audio-fg;
        }

        #pulseaudio.muted {
            background: linear-gradient(to top, @color-widget-audio-muted-bg, mix(@color-widget-audio-muted-bg, @color-gradient-fade, 0.25));
            color: @color-widget-audio-muted-fg;
        }

        #keyboard-state {
            background: linear-gradient(to top, @color-widget-keyboard-state-bg, mix(@color-widget-keyboard-state-bg, @color-gradient-fade, 0.25));
            color: @color-widget-keyboard-state-fg;
        }

        #keyboard-state > label {
            padding: 0px;
        }

        #keyboard-state > label.locked {
            background: transparent;
        }

        #language {
            background: linear-gradient(to top, @color-widget-language-bg, mix(@color-widget-language-bg, @color-gradient-fade, 0.25));
            color: @color-widget-language-fg;
        }

        #wireplumber {
            background-color: #ff0000;
            color: #00ff00;
        }

        #wireplumber.muted {
            background-color: #0000ff;
        }

        #custom-media {
            background-color: #ff0000;
            color: #0000ff;
            min-width: 100px;
        }

        #custom-media.custom-spotify {
            background-color: #00ff00;
        }

        #custom-media.custom-vlc {
            background-color: #ff0000;
        }

        #temperature {
            background: linear-gradient(to top, @color-widget-temperature-bg, mix(@color-widget-temperature-bg, @color-gradient-fade, 0.25));
            color: @color-widget-temperature-fg;
        }

        #temperature.critical {
            background: linear-gradient(to top, @color-widget-temperature-critical-bg, mix(@color-widget-temperature-critical-bg, @color-gradient-fade, 0.25));
            color: @color-widget-temperature-critical-fg;
        }

        #tray {
            background: linear-gradient(to top, @color-widget-tray-bg, mix(@color-widget-tray-bg, @color-gradient-fade, 0.25));
        }

        #tray > .passive {
            -gtk-icon-effect: dim;
        }

        #tray > .needs-attention {
            -gtk-icon-effect: highlight;
            background: linear-gradient(to top, @color-widget-tray-needs-attention, mix(@color-widget-tray-needs-attention, @color-gradient-fade, 0.25));
        }

        #network {
            background: linear-gradient(to top, @color-widget-network-bg, mix(@color-widget-network-bg, @color-gradient-fade, 0.25));
            color: @color-widget-network-fg;
        }

        #custom-notification {
            background: linear-gradient(to top, @color-widget-custom-notification-bg, mix(@color-widget-custom-notification-bg, @color-gradient-fade, 0.25));
            color: @color-widget-custom-notification-fg;
        }

        tooltip {
            background-color: @color-tooltip-bg;
            border: none;
            border-radius: 20px;
        }

        tooltip decoration {
            box-shadow: none;
        }

        tooltip decoration:backdrop {
            box-shadow: none;
        }

        tooltip label {
            color: @color-tooltip-fg;
            padding: 3px 7px;
        }


        menu {
          border-width: 2px;
          border-style: solid;
          border-color: @color-menu-fg;
          background: @color-menu-bg;
          border-radius: 10px;
        }

        menuitem {
          border-radius: 10px;
        }

        menuitem:hover {
          color:  @color-menuitem-hover-fg;
          background: @color-menuitem-hover-bg;
        }

      '';
    };
  };
}
