{ ... }:
''
  * {
    border: none;
    border-radius: 0;
    font-family: "Iosevka q SemiBold", "Material Design Icons", monospace;
    font-size: 11px;
    min-height: 0;
    margin: 0px;
  }

  window#waybar {
    /*background: #000000;*/
  }

  #window {
    font-weight: bold;
  }

  #workspaces {
    padding: 0px;
    margin: 0px;
  }

  #workspaces button {
    padding: 0 2px;
    margin: 0px;
    background: transparent;
    font-weight: bold;
  }
  #workspaces button:hover {
    box-shadow: inherit;
    text-shadow: inherit;
  }

  #workspaces button.active {
  }

  #workspaces button.urgent {
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
  }
  #battery.critical:not(.charging) {
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
    margin: 0 2px;
  }

  #tray {
  }
''
