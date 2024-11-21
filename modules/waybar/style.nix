{ config, ... }:
let
  inherit (config.colorScheme) palette;
in
''
  * {
    border: none;
    border-radius: 0;
    font-family: "Iosevka q Semibold", "Material Design Icons", monospace;
    font-size: 11px;
    min-height: 0;
    margin: 0px;
  }

  window#waybar {
    /*background: #000000;*/
    background-color: #${palette.base00};
    color: #${palette.base05};
  }

  #window {
    color: #${palette.base04};
    font-weight: bold;
  }

  #workspaces {
    padding: 0px;
    margin: 0px;
  }

  #workspaces button {
    padding: 0 2px;
    margin: 0px;
    color: #${palette.base09};
    border: 1px solid #${palette.base01};
    background: transparent;
    font-weight: bold;
  }
  #workspaces button:hover {
    box-shadow: inherit;
    text-shadow: inherit;
  }

  #workspaces button.active {
    background: #${palette.base08};
    color: #${palette.base00};
  }

  #workspaces button.urgent {
    background: #${palette.base08};
    color: #${palette.base00};
  }

  #clock,
  #battery,
  #cpu,
  #memory,
  #network,
  #pulseaudio,
  #custom-spotify,
  #tray,
  #mode {
    padding: 0 3px;
    margin: 0 2px;
  }

  #clock {
  }

  #battery {
  }

  #battery icon {
    color: red;
  }

  #battery.charging {
  }

  @keyframes blink {
    to {
      background-color: #df3320;
    }
  }

  #battery.warning:not(.charging) {
    background-color: #${palette.base09};
    color: #${palette.base00};
  }
  #battery.critical:not(.charging) {
    color: #${palette.base05};
    animation-name: blink;
    animation-duration: 0.5s;
    animation-timing-function: linear;
    animation-iteration-count: infinite;
    animation-direction: alternate;
  }

  #cpu {
  }

  #memory {
  }

  #network {
  }

  #network.disconnected {
    background: #f53c3c;
  }

  #pulseaudio {
  }

  #pulseaudio.muted {
  }

  #custom-spotify {
    color: rgb(102, 220, 105);
  }


  #custom-separator {
    color: #${palette.base03};
    margin: 0 2px;
  }

  #tray {
  }
''
