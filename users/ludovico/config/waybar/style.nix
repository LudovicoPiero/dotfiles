{colorscheme}:
with colorscheme.colors; ''
  * {
    border: none;
    border-radius: 0;
    font-family: Iosevka Nerd Font;
    font-size: 14px;
    min-height: 0;
  }

  window#waybar {
    background: transparent;
    color: #${base05};
  }

  #workspaces {
    background-color: #${base00};
    margin: 5px;
    margin-left: 10px;
    /*border-radius: 5px;*/
  }

  #workspaces button {
    padding: 5px 10px;
    color: #${base05};
  }

  #workspaces button.active {
    color: #${base00};
    background-color: #${base0C};
    /*border-radius: 5px;*/
  }

  #workspaces button:hover {
    color: #${base0C};
    /*border-radius: 5px;*/
  }

  #tray {
    color: #${base00};
    /*border-radius: 5px;*/
  }

  #custom-vpn {
    color: #${base06};
    /*border-radius: 5px 0px 0px 5px;*/
  }

  #tray,
  #custom-date,
  #custom-vpn,
  #clock,
  #battery,
  #pulseaudio,
  #network {
    background-color: #${base00};
    padding: 5px 10px;
    margin: 5px 0px;
  }

  #custom-date {
    color: #${base0E};
  }

  #clock {
    color: #${base0F};
    /*border-radius: 0px 5px 5px 0px;*/
    margin-right: 10px;
  }

  #battery {
    color: #${base0D};
  }

  #battery.charging {
    color: #${base0B};
  }

  #battery.warning:not(.charging) {
    background-color: #${base08};
    color: #${base00};
    /*border-radius: 5px 5px 5px 5px;*/
  }

  #network {
    color: #${base0B};
  }

  #pulseaudio {
    color: #${base0A};
  }

''
