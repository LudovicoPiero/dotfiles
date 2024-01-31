{ config, ... }:
let
  inherit (config.colorScheme) palette;
in
''
  * {
    border: none;
    border-radius: 0;
    font-family:
      "Iosevka q Semibold",
      "Material Design Icons",
      monospace;
    font-size: 14px;
    min-height: 0;
  }

  window#waybar {
    background-color: #${palette.base00};
    /* color: #${palette.base05}; */
  }

  #workspaces {
    background-color: #${palette.base0C};
    margin: 2px;
    margin-left: 2px;
    border-radius: 0px;
  }

  #workspaces button {
    padding: 0px 5px;
    background-color: #${palette.base00};
    border-radius: 0px;
  }

  #workspaces button.empty {
    color: #${palette.base0C};
    background-color: #${palette.base00};
  }

  #workspaces button.visible {
    color: #${palette.base00};
    background-color: #${palette.base09};
  }

  #workspaces button.active {
    color: #${palette.base00};
    background-color: #${palette.base09};
  }

  #workspaces button:hover {
    color: #${palette.base00};
    background-color: #${palette.base0A};
  }

  #tags {
    background-color: #${palette.base00};
    margin: 2px;
    margin-left: 2px;
    border-radius: 0px;
  }

  #tags button {
    padding: 0px 5px;
    color: #${palette.base05};
  }

  #tags button.occupied {
    color: #${palette.base01};
    background-color: #${palette.base07};
    border-radius: 0px;
  }


  #tags button.focused {
    color: #${palette.base01};
    background-color: #${palette.base0D};
    border-radius: 0px;
  }

  #tags button:hover {
    background-color: #${palette.base0D};
    color: #${palette.base00};
    border-radius: 0px;
  }

  #tray {
    border-radius: 0px;
  }
  #tray > .passive {
      -gtk-icon-effect: dim;
  }
  #tray > .needs-attention {
      -gtk-icon-effect: highlight;
  }
  #tray > .active {
  }

  #custom-wireguard {
    color: #${palette.base09};
  }

  #custom-teavpn {
    color: #${palette.base09};
  }

  #privacy {
    color: #${palette.base0D};
  }

  #tray,
  #custom-date,
  #custom-wireguard,
  #custom-teavpn,
  #clock,
  #battery,
  #pulseaudio,
  #privacy,
  #network {
    background-color: #${palette.base00};
    padding: 0px 5px;
    margin: 2px;
  }

  #custom-date {
    color: #${palette.base0A};
  }

  #clock {
    color: #${palette.base0B};
    margin-right: 2px;
  }

  #battery {
    color: #${palette.base0E};
  }

  #battery.charging {
    color: #${palette.base0B};
  }

  #battery.warning:not(.charging) {
    background-color: #${palette.base00};
    color: #${palette.base08};
    border-radius: 0px 0px 0px 0px;
  }

  #network {
    color: #${palette.base0C};
    border-radius: 0px 0px 0px 0px;
  }

  #pulseaudio {
    color: #${palette.base08};
  }
''
