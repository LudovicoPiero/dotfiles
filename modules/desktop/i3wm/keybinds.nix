{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) getExe getExe' mkIf;
  cfg = config.mine.i3;
in
{
  config = mkIf cfg.enable {
    hj.xdg.config.files."i3/config.d/keybinds.conf".text = ''
      bindsym $mod+Return exec ${getExe pkgs.${config.mine.vars.terminal}}
      bindsym $mod+e exec ${getExe' pkgs.emacs "emacsclient"} -c
      bindsym $mod+Shift+e exec ${getExe pkgs.thunar}
      bindsym $mod+m exec ${getExe pkgs.thunderbird}
      bindsym $mod+p exec ${getExe pkgs.rofi} -show drun
      bindsym $mod+Shift+p exec ${getExe pkgs.rofi} -show window

      bindsym $mod+o exec x11-clipboard-picker

      bindsym Print exec x11-ocr
      bindsym Mod1+Print exec x11-screenshot
      bindsym Control+Print exec ${getExe pkgs.flameshot} gui

      bindsym $mod+x exec x11-powermenu
      bindsym $mod+w kill
      bindsym $mod+Shift+c exec i3-msg exit
      bindsym $mod+q scratchpad show
      bindsym $mod+Shift+q move scratchpad
      bindsym $mod+f fullscreen toggle
      bindsym $mod+space floating toggle
      bindsym $mod+r layout toggle split

      bindsym $mod+h focus left
      bindsym $mod+l focus right
      bindsym $mod+k focus up
      bindsym $mod+j focus down

      bindsym $mod+Shift+h move left
      bindsym $mod+Shift+l move right
      bindsym $mod+Shift+k move up
      bindsym $mod+Shift+j move down

      bindsym $mod+1 workspace number 1
      bindsym $mod+2 workspace number 2
      bindsym $mod+3 workspace number 3
      bindsym $mod+4 workspace number 4
      bindsym $mod+5 workspace number 5
      bindsym $mod+6 workspace number 6
      bindsym $mod+7 workspace number 7
      bindsym $mod+8 workspace number 8
      bindsym $mod+9 workspace number 9
      bindsym $mod+0 workspace number 10

      bindsym $mod+Shift+1 move container to workspace number 1
      bindsym $mod+Shift+2 move container to workspace number 2
      bindsym $mod+Shift+3 move container to workspace number 3
      bindsym $mod+Shift+4 move container to workspace number 4
      bindsym $mod+Shift+5 move container to workspace number 5
      bindsym $mod+Shift+6 move container to workspace number 6
      bindsym $mod+Shift+7 move container to workspace number 7
      bindsym $mod+Shift+8 move container to workspace number 8
      bindsym $mod+Shift+9 move container to workspace number 9
      bindsym $mod+Shift+0 move container to workspace number 10

      bindsym XF86AudioRaiseVolume exec ${getExe' pkgs.wireplumber "wpctl"} set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%+
      bindsym XF86AudioLowerVolume exec ${getExe' pkgs.wireplumber "wpctl"} set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%-
      bindsym XF86AudioMute exec ${getExe' pkgs.wireplumber "wpctl"} set-mute @DEFAULT_AUDIO_SINK@ toggle
      bindsym XF86MonBrightnessUp exec ${getExe pkgs.brightnessctl} -e4 -n2 set 5%+
      bindsym XF86MonBrightnessDown exec ${getExe pkgs.brightnessctl} -e4 -n2 set 5%-
      bindsym XF86AudioPlay exec ${getExe pkgs.playerctl} play-pause
      bindsym XF86AudioNext exec ${getExe pkgs.playerctl} next
      bindsym XF86AudioPrev exec ${getExe pkgs.playerctl} previous
    '';
  };
}
