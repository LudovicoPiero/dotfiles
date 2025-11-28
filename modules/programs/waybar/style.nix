{ config, lib, ... }:
let
  inherit (config.mine.theme.colorScheme) palette;
  cfgmine = config.mine;
in
lib.mkIf cfgmine.waybar.enable {
  hj = {
    xdg.config.files."waybar/style.css".text = ''
      /* Reset all styles to ensure square, monospace look */
      * {
          border: none;
          border-radius: 0;
          font-family: monospace;
          font-size: 13px;
          min-height: 0;
          margin: 0;
          padding: 0;
      }

      window#waybar {
          background-color: #${palette.base00};
          color: #${palette.base05};
      }

      #waybar box.right.modules > widget > label,
      #waybar box.right.modules > widget > box {
          padding: 0 5px;
          background-color: #${palette.base00};
          color: #${palette.base05};
      }

      /* Workspaces Default state (Hidden/Empty) */
      #workspaces button,
      #tags button {
          padding: 0 5px;
          background-color: #${palette.base00};
          color: #${palette.base03}; /* Dim color for empty/unused */
          border-bottom: 2px solid transparent;
      }

      /* Occupied State */
      /* Hyprland: Default button is occupied. .empty is empty. */
      #workspaces button {
          color: #${palette.base0D};
      }
      #workspaces button.empty {
          color: #${palette.base03};
      }

      /* DWL/Tags: Explicit .occupied class */
      #tags button.occupied {
          color: #${palette.base0D};
      }

      /* Active/Focused Workspace */
      #workspaces button.active,
      #workspaces button.focused,
      #tags button.focused {
          background-color: #${palette.base02};
          color: #${palette.base05};
          border-bottom: 2px solid #${palette.base05};
      }

      /* Urgent Workspace */
      #workspaces button.urgent,
      #tags button.urgent {
          background-color: #${palette.base08};
          color: #${palette.base00};
      }

      #battery.charging { color: #${palette.base0B}; }
      #battery.warning:not(.charging) { color: #${palette.base0A}; }
      #battery.critical:not(.charging) { color: #${palette.base08}; }

      #network.disconnected { color: #${palette.base08}; }

      #memory.warning { color: #${palette.base0A}; }
      #memory.critical { color: #${palette.base08}; }

      #cpu.warning { color: #${palette.base0A}; }
      #cpu.critical { color: #${palette.base08}; }
      #custom-date {
        color: #${palette.base05};
        padding-right: 5px;
        margin-top: -3px;
      }

      #pulseaudio.muted {
          color: #${palette.base03};
      }

      #mpd.playing {
        color: #${palette.base0B};
      }

      #mpd.stopped {
        color: #${palette.base05};
      }

      #tray > .needs-attention {
        -gtk-icon-effect: highlight;
      }
    '';
  };
}
