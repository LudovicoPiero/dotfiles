{ config, osConfig, ... }:
let
  inherit (config.colorScheme) palette;
in
''
  * {
    border: none;
    border-radius: 0;
    font-family:
      "${osConfig.myOptions.fonts.main.name}",
      "Material Design Icons",
      monospace;
    font-size: 14px;
    min-height: 0;
  }

  window#waybar {
    background-color: #${palette.base00};
  }

  #workspaces {
    margin: 2px;
    margin-left: 2px;
    border-radius: 0px;
  }

  #workspaces button {
    color: #${palette.base05};
    padding: 0px 5px;
    background-color: #${palette.base00};
    border-radius: 0px;
  }

  #workspaces button.empty {
    color: #${palette.base04};
    background-color: #${palette.base00};
  }

  #workspaces button.visible {
    color: #${palette.base04};
  }

  #workspaces button.active {
    color: #${palette.base00};
    background-color: #${palette.base07};
  }

  #workspaces button:hover {
    color: #${palette.base00};
    background-color: #${palette.base0E};
  }

  #submap {
    color: #${palette.base05};
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

  #custom-disk_root {
      color: #${palette.base09};
  }

  #custom-disk_home {
      color: #${palette.base0A};
  }

  #privacy {
      color: #${palette.base0B};
  }

  #network {
      color: #${palette.base0C};
      border-radius: 0px 0px 0px 0px;
  }

  #custom-wireguard {
      color: #${palette.base0C};
  }

  #custom-teavpn {
      color: #${palette.base0C};
  }

  #pulseaudio {
      color: #${palette.base0D};
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

  #custom-date {
      color: #${palette.base0F};
  }

  #clock {
      color: #${palette.base0F};
      margin-right: 2px;
  }

  #tray,
  #custom-disk_root,
  #custom-disk_home,
  #custom-date,
  #custom-wireguard,
  #custom-teavpn,
  #clock,
  #battery,
  #pulseaudio,
  #privacy,
  #submap,
  #network {
    background-color: #${palette.base00};
    padding: 0px 5px;
    margin: 2px;
  }
''
