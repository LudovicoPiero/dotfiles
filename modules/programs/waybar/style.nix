{ config, ... }:
let
  inherit (config.mine.theme.colorScheme) palette;
in
{
  hm.programs.waybar.style = ''
    * {
      font-family:
        "${config.mine.fonts.terminal.name} Semibold",
        "${config.mine.fonts.icon.name}",
        monospace;
      font-size: ${toString config.mine.fonts.size}px;
    }

    window#waybar {
      background-color: #${palette.base00};
      color: #${palette.base05};
      border-bottom: 2px solid #${palette.base01};
      transition-property: background-color;
      transition-duration: 0.5s;
    }

    window#waybar.hidden {
      opacity: 0.5;
    }

    #custom-menu {
      background-color: #${palette.base01};

      font-size: 18px;
      border-radius: 0px 14px 0px 0px;
      margin: 0px 0px 0px 0px;
      padding: 2px 8px 2px 8px;
    }

    #custom-disk_home {
      color: #${palette.base0D};
    }

    #custom-tailscale {
      color: #${palette.base0B};
    }
    #custom-wireguard {
      color: #${palette.base0B};
    }

    #custom-disk_root {
      color: #${palette.base0D};
    }

    #custom-power {
      background-color: #${palette.base08};
      font-size: 16px;
    }

    #custom-power,
    #custom-themes {
      color: #${palette.base00};
      border-radius: 10px;
      margin: 6px 6px 6px 0px;
      padding: 2px 8px 2px 8px;
    }

    #idle_inhibitor {
      background-color: #${palette.base0B};
      color: #${palette.base00};
      border-radius: 10px;
      margin: 6px 0px 6px 6px;
      padding: 4px 6px;
    }

    #idle_inhibitor.deactivated {
      background-color: #${palette.base08};
    }

    #tray {
    }

    #tray > .passive {
      -gtk-icon-effect: dim;
    }

    #tray > .needs-attention {
      -gtk-icon-effect: highlight;
    }

    #tray > .active {
    }

    @keyframes gradient {
      0% {
        background-position: 0% 50%;
      }

      50% {
        background-position: 100% 50%;
      }

      100% {
        background-position: 0% 50%;
      }
    }

    #mpd {
      color: #${palette.base05};
    }

    #mpd.disconnected {
      color: #${palette.base08};
    }

    #mpd.stopped {
      color: #${palette.base08};
    }

    #mpd.playing {
      color: #${palette.base0C};
    }

    #mpd.paused {
    }

    #mpd.2 {
      border-radius: 10px 0px 0px 10px;
      margin: 6px 0px 6px 6px;
      padding: 4px 6px 4px 10px;
    }

    #mpd.3 {
      margin: 6px 0px 6px 0px;
      padding: 4px;
    }

    #mpd.4 {
      border-radius: 0px 10px 10px 0px;
      margin: 6px 6px 6px 0px;
      padding: 4px 10px 4px 6px;
    }

    #mpd.2,
    #mpd.3,
    #mpd.4 {
      background-color: #${palette.base01};
      font-size: 14px;
    }

    #custom-spotify {
      background-color: #${palette.base01};
      color: #${palette.base05};
      border-radius: 10px;
      margin: 6px 0px 6px 6px;
      padding: 4px 8px;
      font-size: 12px;
      font-weight: bold;
    }

    #custom-spotify.paused {
      color: #${palette.base05};
    }

    #custom-spotify.playing {
      background: linear-gradient(
        90deg,
        #${palette.base09} 25%,
        #${palette.base08} 50%,
        #${palette.base0A} 75%,
        #${palette.base0C} 100%
      );
      background-size: 300% 300%;
      animation: gradient 10s ease infinite;
      color: #${palette.base00};
    }

    #custom-spotify.offline {
      color: #${palette.base08};
    }

    #cpu {
      color: #${palette.base08};
    }

    #disk {
      color: #${palette.base0A};
    }

    #pulseaudio {
      color: #${palette.base0D};
    }

    #pulseaudio.bluetooth {
      color: #${palette.base0C};
    }

    #pulseaudio.muted {
      color: #${palette.base08};
    }

    #pulseaudio.2 {
    }

    #pulseaudio.2.bluetooth {
    }

    #pulseaudio.2.muted {
    }

    #backlight {
      color: #${palette.base09};
    }

    #battery {
      color: #${palette.base0C};
    }

    #battery.charging {
    }

    #battery.plugged {
    }

    @keyframes blink {
      to {
        color: #${palette.base05};
      }
    }

    #battery.critical:not(.charging) {
      background-color: #${palette.base02};
    }

    #battery.2.critical:not(.charging) {
      background-color: #${palette.base01};
      color: #${palette.base08};
      animation-name: blink;
      animation-duration: 0.5s;
      animation-timing-function: linear;
      animation-iteration-count: infinite;
      animation-direction: alternate;
    }

    #bluetooth {
      color: #${palette.base0B};
    }

    #bluetooth.disabled {
      color: #${palette.base08};
    }

    #bluetooth.off {
      color: #${palette.base08};
    }

    #bluetooth.on {
    }

    #bluetooth.connected {
    }

    #bluetooth.discoverable {
    }

    #bluetooth.discovering {
    }

    #bluetooth.pairable {
    }

    #clock {
      color: #${palette.base0D};
    }

    #custom-date {
      color: #${palette.base0D};
    }

    #network {
      color: #${palette.base0E};
    }

    #submap {
      background-color: #${palette.base00};
      color: #${palette.base05};
    }

    #workspaces {
      background-color: #${palette.base00};
      margin: 6px;
      padding: 0px;
    }

    #workspaces button {
      color: #${palette.base05};
      padding: 5px;
      background-color: #${palette.base00};
      border-radius: 10px;
    }

    #workspaces button.empty {
      color: #${palette.base04};
      background-color: #${palette.base00};
    }

    #workspaces button.visible {
      color: #${palette.base04};
    }

    #workspaces button.focused {
      color: #${palette.base00};
      background-color: #${palette.base07};
    }

    #workspaces button.active {
      color: #${palette.base00};
      background-color: #${palette.base07};
    }

    #workspaces button:hover {
      color: #${palette.base00};
      background-color: #${palette.base0E};
    }

    #backlight,
    #battery,
    #clock,
    #cpu,
    #custom-date,
    #custom-disk_root,
    #custom-disk_home,
    #custom-wireguard,
    #custom-tailscale,
    #disk,
    #mpd,
    #tray,
    #pulseaudio,
    #network,
    #bluetooth {
      background-color: #${palette.base02};
      border-radius: 10px 0px 0px 10px;
      margin: 6px 0px 6px 0px;
      padding: 4px 6px;
    }

    #backlight.2,
    #mpd.2,
    #battery.2,
    #clock.2,
    #cpu.2,
    #disk.2,
    #pulseaudio.2,
    #network.2,
    #bluetooth.2 {
      background-color: #${palette.base01};
      color: #${palette.base05};
      font-size: 12px;
      font-weight: bold;
      border-radius: 0px 10px 10px 0px;
      margin: 6px 6px 6px 0px;
      padding: 5px 6px 4px 6px;
    }
  '';
}
