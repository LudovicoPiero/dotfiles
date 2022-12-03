{
  pkgs,
  config,
  ...
}: let
  modifier = config.xsession.windowManager.i3.config.modifier;
in {
  "${modifier}+Return" = "exec ${pkgs.kitty}/bin/kitty";
  "${modifier}+p" = "exec ${pkgs.dmenu}/bin/dmenu_run";

  # Discord
  "${modifier}+d" = "exec ${pkgs.discord-canary}/bin/discordcanary --ignore-gpu-blocklist --disable-features=UseOzonePlatform --enable-features=VaapiVideoDecoder --use-gl=desktop --enable-gpu-rasterization --enable-zero-copy";

  # Enter resize mode
  "${modifier}+r" = "mode \"resize\"";

  # Kill apps
  "${modifier}+w" = "kill";

  # Exit i3
  "${modifier}+Shift+e" = "exec i3-nagbar -t warning -m 'You pressed the exit shortcut. Do you really want to exit i3? This will end your X session.' -b 'Yes, exit i3' 'i3-msg exit'";

  # restart i3 inplace (preserves your layout/session, can be used to upgrade i3)
  "${modifier}+Shift+r" = "restart";

  # reload config
  "${modifier}+Shift+c" = "reload";

  # Toggle tiling / floating
  "${modifier}+space" = "floating toggle";

  # Toggle fullscreen
  "${modifier}+f" = "fullscreen toggle";

  # Split
  "${modifier}+g" = "split h";
  "${modifier}+v" = "split v";

  # Change focus
  "${modifier}+j" = "focus down";
  "${modifier}+k" = "focus up";
  "${modifier}+l" = "focus right";
  "${modifier}+h" = "focus left";
  "${modifier}+Tab" = "focus parent";
  "${modifier}+q" = "focus child";

  # Audio controls
  "XF86AudioRaiseVolume" = "exec ${pkgs.alsa-utils}/bin/amixer -q set Master 5%+";
  "XF86AudioLowerVolume" = "exec ${pkgs.alsa-utils}/bin/amixer -q set Master 5%-";
  "XF86AudioMute" = "exec ${pkgs.alsa-utils}/bin/amixer -q set Master toggle";
  "XF86AudioPlay" = "exec ${pkgs.playerctl}/bin/playerctl play-pause";
  "XF86AudioNext" = "exec ${pkgs.playerctl}/bin/playerctl next";
  "XF86AudioPrev" = "exec ${pkgs.playerctl}/bin/playerctl previous";
  "XF86AudioStop" = "exec ${pkgs.playerctl}/bin/playerctl stop";

  # Brightness controls
  "XF86MonBrightnessUp" = "exec ${pkgs.xorg.xbacklight}/bin/xbacklight -inc 10";
  "XF86MonBrightnessDown" = "exec ${pkgs.xorg.xbacklight}/bin/xbacklight -dec 10";

  # Workspace
  "${modifier}+1" = "workspace 1";
  "${modifier}+2" = "workspace 2";
  "${modifier}+3" = "workspace 3";
  "${modifier}+4" = "workspace 4";
  "${modifier}+5" = "workspace 5";
  "${modifier}+6" = "workspace 6";
  "${modifier}+7" = "workspace 7";
  "${modifier}+8" = "workspace 8";
  "${modifier}+9" = "workspace 9";
  "${modifier}+0" = "workspace 10";

  # Move focused container to workspace
  "${modifier}+Shift+1" = "move container to workspace 1";
  "${modifier}+Shift+2" = "move container to workspace 2";
  "${modifier}+Shift+3" = "move container to workspace 3";
  "${modifier}+Shift+4" = "move container to workspace 4";
  "${modifier}+Shift+5" = "move container to workspace 5";
  "${modifier}+Shift+6" = "move container to workspace 6";
  "${modifier}+Shift+7" = "move container to workspace 7";
  "${modifier}+Shift+8" = "move container to workspace 8";
  "${modifier}+Shift+9" = "move container to workspace 9";
  "${modifier}+Shift+0" = "move container to workspace 10";
}
