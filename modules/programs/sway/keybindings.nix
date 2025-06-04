{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  inherit (lib) getExe getExe';

  cfg = config.mine.sway;
  cfgsway = config.hm.wayland.windowManager.sway.config;

  mod = cfgsway.modifier;
  amixer = "${getExe' pkgs.alsa-utils "amixer"}";
  brightnessctl = "${getExe pkgs.brightnessctl}";
  playerctl = "${getExe pkgs.playerctl}";
  clipboard = "${getExe pkgs.cliphist} list | ${getExe pkgs.fuzzel} --dmenu | ${getExe pkgs.cliphist} decode | ${getExe' pkgs.wl-clipboard "wl-copy"}";
  emojiPicker = getExe inputs.ludovico-pkgs.packages.${pkgs.stdenv.hostPlatform.system}.fuzzmoji;

  app2unit =
    if cfg.withUWSM then
      "${getExe inputs.ludovico-pkgs.packages.${pkgs.stdenv.hostPlatform.system}.app2unit} --"
    else
      "";
in
{
  hm = {
    wayland.windowManager.sway.config.keybindings = {
      # Kill focused window
      "${mod}+w" = "kill";

      # Reload the configuration file
      "${mod}+Shift+r" = "reload";

      # Wleave
      "${mod}+x" = "exec ${getExe pkgs.wleave}";

      # Exit sway
      "${mod}+Shift+c" = "exit";

      ### Moving around
      # Move your focus around
      "${mod}+h" = "focus left";
      "${mod}+l" = "focus right";

      # Move the focused window with the same, but add Shift
      "${mod}+Shift+h" = "move left";
      "${mod}+Shift+j" = "move down";
      "${mod}+Shift+k" = "move up";
      "${mod}+Shift+l" = "move right";

      ### Workspaces
      # Switch to workspace
      "${mod}+1" = "workspace 1";
      "${mod}+2" = "workspace 2";
      "${mod}+3" = "workspace 3";
      "${mod}+4" = "workspace 4";
      "${mod}+5" = "workspace 5";
      "${mod}+6" = "workspace 6";
      "${mod}+7" = "workspace 7";
      "${mod}+8" = "workspace 8";
      "${mod}+9" = "workspace 9";

      # Move focused container to workspace
      "${mod}+Shift+1" = "move container to workspace 1";
      "${mod}+Shift+2" = "move container to workspace 2";
      "${mod}+Shift+3" = "move container to workspace 3";
      "${mod}+Shift+4" = "move container to workspace 4";
      "${mod}+Shift+5" = "move container to workspace 5";
      "${mod}+Shift+6" = "move container to workspace 6";
      "${mod}+Shift+7" = "move container to workspace 7";
      "${mod}+Shift+8" = "move container to workspace 8";
      "${mod}+Shift+9" = "move container to workspace 9";

      ### Resizing containers
      "${mod}+s" = "mode resize";
      "${mod}+Left" = "resize shrink width 10px";
      "${mod}+Right" = "resize grow width 10px";
      "${mod}+Down" = "resize shrink height 10px";
      "${mod}+Up" = "resize grow height 10px";

      ### Scratchpad
      # Move the currently focused window to the scratchpad
      "${mod}+Shift+q" = "move scratchpad";

      # Show the next scratchpad window or hide the focused scratchpad window.
      # If there are multiple scratchpad windows, this command cycles through them.
      "${mod}+q" = "scratchpad show";

      # Fullscreen
      "${mod}+f" = "fullscreen";

      ### Layout stuff
      "${mod}+c" = "splith";
      "${mod}+v" = "splitv";

      # Switch the current container between different layout styles
      "${mod}+r" = "layout stacking";
      "${mod}+e" = "layout toggle split";
      "${mod}+t" = "layout tabbed";

      # Toggle the current focus between tiling and floating mode
      "${mod}+Space" = "floating toggle";

      ### Apps
      "${mod}+Return" = "exec ${app2unit} '${cfgsway.terminal}'";

      "${mod}+o" = "exec ${app2unit} ${clipboard}";
      "${mod}+Shift+o" = "exec ${app2unit} '${emojiPicker}'";
      "${mod}+p" = "exec ${app2unit} '${cfgsway.menu}'";
      "${mod}+g" = "exec ${app2unit} 'firefox'";
      "${mod}+Shift+g" = "exec ${app2unit} 'zen-beta'";
      "${mod}+d" = "exec ${app2unit} 'vesktop'";
      "${mod}+Shift+e" = "exec ${app2unit} '${getExe pkgs.xfce.thunar}'";

      ### Screenshot
      "Print" = "exec wl-ocr";
      "CTRL+Print" = "exec ${getExe pkgs.grimblast} save area - | ${getExe pkgs.swappy} -f -";
      "ALT+Print" =
        "exec ${getExe pkgs.grimblast} --notify --cursor copysave output ~/Pictures/Screenshots/$(date +'%s.png')";

      # Volume
      # (un)mute output
      XF86AudioMute = "exec ${amixer} set Master toggle";
      # increase output volume
      XF86AudioRaiseVolume = "exec ${amixer} -q set Master 5%+";
      # decrease output volume
      XF86AudioLowerVolume = "exec ${amixer} -q set Master 5%-";

      # Media control
      XF86AudioPlay = "exec ${playerctl} play-pause";
      XF86AudioNext = "exec ${playerctl} next";
      XF86AudioPrev = "exec ${playerctl} previous";
      XF86AudioStop = "exec ${playerctl} stop";

      # Brightness
      XF86MonBrightnessUp = "exec ${brightnessctl} set 5%+";
      XF86MonBrightnessDown = "exec ${brightnessctl} set 5%-";
    };
  };
}
