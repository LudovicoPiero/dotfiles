{ config, ... }:
let
  inherit (config.mine.theme.colorScheme) palette;
in
{
  hm.programs.waybar.style = ''
    * {
      font-family: "${config.mine.fonts.terminal.name}", "${config.mine.fonts.icon.name}", monospace;
      font-size: ${toString config.mine.fonts.size}px;
      border-radius: 0;
    }

    window#waybar {
      background: #${palette.base00};
      color: #${palette.base05};
      border-bottom: 1px solid #${palette.base01};
      border-radius: 0;
    }

    /* --- Workspaces --- */
    #workspaces {
      margin: 0 4px;
    }

    #workspaces button {
      border: none;
      margin: 0 1px;
      padding: 2px 8px;
      background: transparent;
      color: #${palette.base05};
      border-radius: 0;
      transition: background 0.2s, color 0.2s;
    }

    /* Empty workspace (no windows) */
    #workspaces button.empty {
      color: #${palette.base04};
      opacity: 0.6;
    }

    /* Workspace with windows but not focused */
    #workspaces button.visible,
    #workspaces button.active {
      color: #${palette.base05};
      background: #${palette.base03};
    }

    /* Focused workspace */
    #workspaces button.focused {
      color: #${palette.base0D};
      background: #${palette.base00};
      font-weight: bold;
    }

    /* Hover effect */
    #workspaces button:hover {
      background: #${palette.base05};
      color: #${palette.base03};
    }

    #clock,
    #battery,
    #cpu,
    #disk,
    #pulseaudio,
    #network,
    #bluetooth,
    #tray,
    #mpd,
    #custom-spotify,
    #custom-menu,
    #custom-tailscale,
    #custom-wireguard,
    #custom-disk_home,
    #custom-disk_root,
    #custom-power {
      padding: 0 6px;
      margin: 0 2px;
      border-radius: 0;
    }

    #battery.critical:not(.charging) {
      color: #${palette.base08};
    }

    #pulseaudio.muted {
      color: #${palette.base03};
    }

    #mpd.playing,
    #custom-spotify.playing {
      color: #${palette.base0B};
    }

    #mpd.stopped,
    #custom-spotify.paused {
      color: #${palette.base05};
    }

    #custom-menu,
    #custom-power {
      background: #${palette.base08};
      color: #${palette.base00};
      padding: 0 8px;
      border-radius: 0;
    }

    #tray > .needs-attention {
      -gtk-icon-effect: highlight;
    }
  '';
}
