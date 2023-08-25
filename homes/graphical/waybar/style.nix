{config, ...}: let
  inherit (config.colorScheme) colors;
in ''
  * {
    border: none;
    border-radius: 0;
    font-family:
      SF Pro Rounded,
      Material Design Icons,
      monospace;
    font-size: 13px;
    min-height: 0;
  }

  window#waybar {
    background-color: #${colors.base00};
    /* color: #${colors.base05}; */
  }

  #workspaces {
    background-color: #${colors.base00};
    margin: 5px;
    margin-left: 10px;
    border-radius: 0px;
  }

  #workspaces button {
    padding: 5px 10px;
    color: #${colors.base05};
  }

  #workspaces button.active {
    color: #${colors.base00};
    background-color: #${colors.base0D};
    border-radius: 0px;
  }

  #workspaces button:hover {
    background-color: #${colors.base0D};
    color: #${colors.base00};
    border-radius: 0px;
  }

  #tray {
    color: #${colors.base00};
    border-radius: 0px;
  }

  #custom-wireguard {
    color: #${colors.base09};
  }

  #custom-teavpn {
    color: #${colors.base09};
  }

  #tray,
  #custom-date,
  #custom-wireguard,
  #custom-teavpn,
  #clock,
  #battery,
  #pulseaudio,
  #network {
    background-color: #${colors.base00};
    padding: 5px 10px;
    margin: 5px 0px;
  }

  #custom-date {
    color: #${colors.base0A};
  }

  #clock {
    color: #${colors.base0B};
    border-radius: 0px 0px 0px 0px;
    margin-right: 10px;
  }

  #battery {
    color: #${colors.base0E};
  }

  #battery.charging {
    color: #${colors.base0B};
  }

  #battery.warning:not(.charging) {
    background-color: #${colors.base00};
    color: #${colors.base08};
    border-radius: 0px 0px 0px 0px;
  }

  #network {
    color: #${colors.base0C};
    border-radius: 0px 0px 0px 0px;
  }

  #pulseaudio {
    color: #${colors.base08};
  }
''
