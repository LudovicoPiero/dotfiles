{config, ...}: let
  inherit (config.vars.colorScheme) colors;
in ''
  * {
    font-family: "JetBrainsMono Nerd Font", "Iosevka Nerd Font", sans-serif;
    font-size: 12px;
  }

  /** ********** Waybar Window ********** **/
  window#waybar {
      background: #${colors.base00};
      border-top: 2px solid #2D3039;
      transition-property: background-color;
      transition-duration: .5s;
  }

  window#waybar.hidden {
      opacity: 0.5;
  }

  window#waybar.empty {
  }
  window#waybar.solo {
  }
  window#waybar.thunar {
  }
  window#waybar.geany {
  }

  /** ********** Battery ********** **/
  #battery {
      border-bottom: 2px solid #${colors.base0D};
  }

  #battery.charging {
  }

  #battery.plugged {
  }

  @keyframes blink {
      to {
          color: #${colors.base08};
      }
  }

  #battery.critical:not(.charging) {
      color: #${colors.base05};
      border-bottom: 2px solid #${colors.base08};
      animation-name: blink;
      animation-duration: 0.5s;
      animation-timing-function: linear;
      animation-iteration-count: infinite;
      animation-direction: alternate;
  }

  /** ********** Clock ********** **/
  #clock {
      border-bottom: 2px solid #${colors.base0B};
  }

  #cpu {
      border-bottom: 2px solid #${colors.base09};
  }

  #memory {
      border-bottom: 2px solid #${colors.base09};
  }

  /** ********** Workspace ********** **/
  #workspaces {
  	background-color: #2D3039;
  	border-radius: 2px;
    border-bottom: 2px solid #${colors.base0C};
  	margin: 6px 0px;
  	padding: 2px 10px;
  }

  #workspaces button {
  	color: #${colors.base05};
  }

  #workspaces button:hover {
  	color: #${colors.base05};
  }

  #workspaces button.visible,
  #workspaces button.focused,
  #workspaces button.active,
  #workspaces button.urgent,
  #workspaces button.persistent {
    color: #${colors.base08};
  }

  /* If workspaces is the leftmost module, omit left margin */
  .modules-left > widget:first-child > #workspaces {
      margin-left: 0;
  }

  /* If workspaces is the rightmost module, omit right margin */
  .modules-right > widget:last-child > #workspaces {
      margin-right: 0;
  }

  /** ********** Tray ********** **/
  #tray {
      border-bottom: 2px solid #${colors.base06};
  }
  #tray > .passive {
      -gtk-icon-effect: dim;
  }
  #tray > .needs-attention {
      -gtk-icon-effect: highlight;
  }
  #tray > .active {
  }

  /** ********** Pulseaudio ********** **/
  #pulseaudio {
      border-bottom: 2px solid #${colors.base09};
  }

  #pulseaudio.bluetooth {
      border-bottom: 2px solid #${colors.base07};
  }
  #pulseaudio.muted {
  	background-color: #${colors.base0E};
  	color: #${colors.base05};
      border-bottom: 2px solid #${colors.base00};
  }

  /** ********** Network ********** **/
  #network {
      border-bottom: 2px solid #${colors.base0E};
  }

  #network.disconnected {
  	background-color: #${colors.base0C};
  	color: #${colors.base00};
    border-bottom: 2px solid #${colors.base00};
  }
  #network.disabled {
  	background-color: #${colors.base08};
  	color: #${colors.base05};
  }
  #network.linked {
  }
  #network.ethernet {
  }
  #network.wifi {
  }

  /** Custom **/
  #custom-date {
      border-bottom: 2px solid #${colors.base08};
  }

  /** ********** Workspace ********** **/
  /*#workspaces
  #workspaces button
  #workspaces button.active
  #workspaces button.urgent
  #workspaces button.hidden */

  /** Common style **/
  #backlight,
  #battery,
  #clock,
  #cpu,
  #memory,
  #mode,
  #window,
  #tray,
  #mpd,
  #pulseaudio,
  #network,
  #custom-date {
    background-color: #2D3039;
  	border-radius: 2px;
  	margin: 6px 0px;
  	padding: 2px 10px;
  }
''
