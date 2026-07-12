{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    getExe
    getExe'
    mkOption
    types
    mkIf
    ;
  cfg = config.mine.i3wm;
  c = config.mine.theme.colors;
in
{
  options.mine.i3wm = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable i3wm configuration.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.i3;
      description = "The i3wm package to install.";
    };
  };

  config = mkIf cfg.enable {
    services = {
      xserver = {
        enable = true;
        windowManager.i3 = {
          enable = true;
          inherit (cfg) package;
          extraSessionCommands = ''
            export XDG_CURRENT_DESKTOP=i3
            systemctl --user import-environment XDG_CURRENT_DESKTOP || true
            dbus-update-activation-environment --systemd XDG_CURRENT_DESKTOP || true
          '';
        };
        xkb.layout = "us";
        autoRepeatDelay = 300;
        autoRepeatInterval = 33;
      };
      libinput = {
        enable = true;
        touchpad = {
          tapping = true;
          naturalScrolling = true;
          middleEmulation = true;
          disableWhileTyping = false;
        };
      };

      picom = {
        enable = true;
        backend = "glx";
        vSync = true;
        fade = false;
        fadeDelta = 4;
        shadow = false;
        shadowOpacity = 0.6;
        settings = {
          shadow-color = c.base00;
          corner-radius = 6;
          blur-method = "none";
          blur-strength = 5;
          rounded-corners-exclude = [
            "window_type = 'dock'"
            "window_type = 'desktop'"
          ];
        };
      };
    };
    security.pam.services.i3lock.text = "auth include login";
    security.pam.services.i3lock-color.text = "auth include login";

    systemd.user.targets.i3-session = {
      description = "i3 window manager session";
      documentation = [ "man:systemd.special(7)" ];
      bindsTo = [ "graphical-session.target" ];
      wants = [ "graphical-session-pre.target" ];
      after = [ "graphical-session-pre.target" ];
    };

    hj = {
      packages = [ cfg.package ];
      xdg.config.files."i3/config".text = ''
        font pango:${config.mine.fonts.main.name} 10
        include ${config.mine.vars.homeDirectory}/.config/i3/window-rules
        exec --no-startup-id ${getExe pkgs.xsetroot} -cursor_name ${config.mine.gtk.cursorTheme.name}

        # Autostart
        exec_always --no-startup-id ${getExe pkgs.xrandr} --output HDMI-A-1 --mode 1920x1080 --rate 180 --pos 0x0 --output eDP-1 --off
        exec --no-startup-id ${getExe pkgs.dunst}
        exec --no-startup-id ${getExe pkgs.thunderbird}
        exec --no-startup-id fcitx5 -d
        exec --no-startup-id ${pkgs.clipmenu}/bin/clipmenud
        exec --no-startup-id ${getExe pkgs.xautolock} -time 10 -locker "${getExe pkgs.betterlockscreen} -l dim" -detectsleep
        exec --no-startup-id ${getExe pkgs.xss-lock} -- ${getExe pkgs.betterlockscreen} -l dim
        exec --no-startup-id ${getExe pkgs.xset} s 1200 1200
        exec --no-startup-id "${getExe' pkgs.i3 "i3-msg"} -t subscribe -m '[\"shutdown\"]' && systemctl --user stop i3-session.target"
        exec --no-startup-id "systemctl --user start i3-session.target || true"
        exec --no-startup-id ${getExe pkgs.feh} --bg-fill $HOME/Pictures/Wallpaper/Minato-Aqua-Dark.png

        floating_modifier Mod4
        default_border normal 2
        default_floating_border normal 2
        hide_edge_borders none
        focus_wrapping no
        focus_follows_mouse yes
        focus_on_window_activation smart
        mouse_warping output
        workspace_layout default
        workspace_auto_back_and_forth no
        client.focused ${c.base0E} ${c.base0E} ${c.base00} ${c.base0E} ${c.base0E}
        client.focused_inactive ${c.base01} ${c.base01} ${c.base05} ${c.base01} ${c.base01}
        client.unfocused ${c.base01} ${c.base01} ${c.base05} ${c.base01} ${c.base01}
        client.urgent ${c.base08} ${c.base08} ${c.base00} ${c.base08} ${c.base08}
        client.placeholder #000000 #0c0c0c #ffffff #000000 #0c0c0c
        client.background ${c.base00}

        bindsym XF86AudioLowerVolume exec --no-startup-id ${getExe' pkgs.pulseaudio "pactl"} set-sink-volume @DEFAULT_SINK@ -5%
        bindsym XF86AudioMicMute exec --no-startup-id ${getExe' pkgs.pulseaudio "pactl"} set-source-mute @DEFAULT_SOURCE@ toggle
        bindsym XF86AudioMute exec --no-startup-id ${getExe' pkgs.pulseaudio "pactl"} set-sink-mute @DEFAULT_SINK@ toggle
        bindsym XF86AudioRaiseVolume exec --no-startup-id ${getExe' pkgs.pulseaudio "pactl"} set-sink-volume @DEFAULT_SINK@ +5%
        bindsym XF86MonBrightnessDown exec --no-startup-id ${getExe pkgs.brightnessctl} set 5%-
        bindsym XF86MonBrightnessUp exec --no-startup-id ${getExe pkgs.brightnessctl} set 5%+

        bindsym Mod4+1 workspace number 1
        bindsym Mod4+2 workspace number 2
        bindsym Mod4+3 workspace number 3
        bindsym Mod4+4 workspace number 4
        bindsym Mod4+5 workspace number 5
        bindsym Mod4+6 workspace number 6
        bindsym Mod4+7 workspace number 7
        bindsym Mod4+8 workspace number 8
        bindsym Mod4+9 workspace number 9
        bindsym Mod4+0 workspace number 10

        bindsym Mod4+Down focus down
        bindsym Mod4+Left focus left
        bindsym Mod4+Return exec --no-startup-id ${getExe pkgs.wezterm}
        bindsym Mod4+Right focus right

        bindsym Mod4+Shift+1 move container to workspace number 1
        bindsym Mod4+Shift+2 move container to workspace number 2
        bindsym Mod4+Shift+3 move container to workspace number 3
        bindsym Mod4+Shift+4 move container to workspace number 4
        bindsym Mod4+Shift+5 move container to workspace number 5
        bindsym Mod4+Shift+6 move container to workspace number 6
        bindsym Mod4+Shift+7 move container to workspace number 7
        bindsym Mod4+Shift+8 move container to workspace number 8
        bindsym Mod4+Shift+9 move container to workspace number 9
        bindsym Mod4+Shift+0 move container to workspace number 10

        bindsym Mod4+Shift+Down move down
        bindsym Mod4+Shift+Left move left
        bindsym Mod4+Shift+Right move right
        bindsym Mod4+Shift+Up move up
        bindsym Mod4+Shift+c reload
        bindsym Mod4+Shift+e exec --no-startup-id ${getExe' pkgs.i3 "i3-nagbar"} -t warning -m 'You pressed the exit shortcut. Do you really want to exit i3? This will end your X session.' -B 'Yes, exit i3' '${getExe' pkgs.i3 "i3-msg"} exit'
        bindsym Mod4+Shift+h move left
        bindsym Mod4+Shift+j move down
        bindsym Mod4+Shift+k move up
        bindsym Mod4+Shift+l move right
        bindsym Mod4+Shift+minus move scratchpad
        bindsym Mod4+Shift+p exec --no-startup-id ${pkgs.clipmenu}/bin/clipmenu
        bindsym Mod4+Shift+q move scratchpad
        bindsym Mod4+Shift+space focus mode_toggle
        bindsym Mod4+Up focus up
        bindsym Mod4+a focus parent
        bindsym Mod4+b splith
        bindsym Mod4+e layout toggle split
        bindsym Mod4+f fullscreen
        bindsym Mod4+h focus left
        bindsym Mod4+j focus down
        bindsym Mod4+k focus up
        bindsym Mod4+l focus right
        bindsym Mod4+minus scratchpad show
        bindsym Mod4+p exec --no-startup-id ${getExe pkgs.rofi} -show drun
        bindsym Mod4+q scratchpad show
        bindsym Mod4+r mode resize
        bindsym Mod4+s layout stacking
        bindsym Mod4+space floating toggle
        bindsym Mod4+t layout tabbed
        bindsym Mod4+v splitv
        bindsym Mod4+w kill
        bindsym Mod4+x exec --no-startup-id ${getExe' pkgs.i3 "i3-nagbar"} -t warning -m 'Power menu' -B 'Lock' '${getExe pkgs.betterlockscreen} -l dim' -B 'Logout' '${getExe' pkgs.i3 "i3-msg"} exit' -B 'Reboot' 'systemctl reboot' -B 'Shutdown' 'systemctl poweroff'
        bindsym Print exec --no-startup-id ${getExe pkgs.maim} -s | ${getExe' pkgs.xclip "xclip"} -selection clipboard -t image/png

        mode "resize" {
          bindsym Down resize grow height 10px
          bindsym Escape mode default
          bindsym Left resize shrink width 10px
          bindsym Return mode default
          bindsym Right resize grow width 10px
          bindsym Up resize shrink height 10px
          bindsym h resize shrink width 10px
          bindsym j resize grow height 10px
          bindsym k resize shrink height 10px
          bindsym l resize grow width 10px
        }

        bar {
          font pango:JetBrains Mono 10.000000
          position bottom
          status_command ${getExe pkgs.i3status} -c ~/.config/i3status/i3status.conf
          colors {
            background ${c.base00}
            statusline ${c.base05}
            focused_workspace ${c.base0E} ${c.base0E} ${c.base01}
            active_workspace ${c.base0D} ${c.base0D} ${c.base01}
            inactive_workspace ${c.base01} ${c.base01} ${c.base04}
            urgent_workspace ${c.base08} ${c.base08} ${c.base01}
          }
        }
      '';
    };
  };
}
