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
    optional
    ;
  cfg = config.mine.sway;
  c = config.mine.theme.colors;
in
{
  options.mine.sway = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable sway configuration.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.sway;
      description = "The sway package to install.";
    };
  };

  config = mkIf cfg.enable {
    services.displayManager.sessionPackages = optional (
      cfg.package != null
    ) cfg.package;
    security.pam.services.swaylock.text = "auth include login";
    systemd.user.targets.sway-session = {
      description = "sway compositor session";
      documentation = [ "man:systemd.special(7)" ];
      bindsTo = [ "graphical-session.target" ];
      wants = [ "graphical-session-pre.target" ];
      after = [ "graphical-session-pre.target" ];
    };

    hj = {
      packages = [ cfg.package ];
      xdg.config.files."sway/config".text = ''
        font pango:${config.mine.fonts.main.name} 10
        include ${config.mine.vars.homeDirectory}/.config/sway/window-rules
        seat * xcursor_theme ${config.mine.gtk.cursorTheme.name} ${toString config.mine.gtk.cursorTheme.size}

        # Autostart
        exec ${getExe pkgs.mako}
        exec ${getExe pkgs.thunderbird}
        exec --no-startup-id fcitx5 -d
        exec ${getExe' pkgs.wl-clipboard "wl-paste"} --type text --watch ${getExe pkgs.cliphist} store
        exec ${getExe' pkgs.wl-clipboard "wl-paste"} --type image --watch ${getExe pkgs.cliphist} store
        exec ${getExe pkgs.swayidle} -w \
          timeout 300 '${getExe pkgs.swaylock} -f -c 000000' \
          timeout 600 'swaymsg "output * power off"' resume 'swaymsg "output * power on"' \
          before-sleep '${getExe pkgs.swaylock} -f -c 000000'
        exec ${getExe' pkgs.dbus "dbus-update-activation-environment"} --systemd DISPLAY WAYLAND_DISPLAY SWAYSOCK XDG_CURRENT_DESKTOP
        exec "systemctl --user import-environment {,WAYLAND_}DISPLAY SWAYSOCK; systemctl --user start sway-session.target"
        exec swaymsg -t subscribe '["shutdown"]' && systemctl --user stop sway-session.target

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

        bindsym --locked XF86AudioLowerVolume exec ${getExe' pkgs.pulseaudio "pactl"} set-sink-volume @DEFAULT_SINK@ -5%
        bindsym --locked XF86AudioMicMute exec ${getExe' pkgs.pulseaudio "pactl"} set-source-mute @DEFAULT_SOURCE@ toggle
        bindsym --locked XF86AudioMute exec ${getExe' pkgs.pulseaudio "pactl"} set-sink-mute @DEFAULT_SINK@ toggle
        bindsym --locked XF86AudioRaiseVolume exec ${getExe' pkgs.pulseaudio "pactl"} set-sink-volume @DEFAULT_SINK@ +5%
        bindsym --locked XF86MonBrightnessDown exec ${getExe pkgs.brightnessctl} set 5%-
        bindsym --locked XF86MonBrightnessUp exec ${getExe pkgs.brightnessctl} set 5%+

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
        bindsym Mod4+Return exec ${getExe pkgs.wezterm}
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
        bindsym Mod4+Shift+e exec swaynag -t warning -m 'You pressed the exit shortcut. Do you really want to exit sway? This will end your Wayland session.' -B 'Yes, exit sway' 'swaymsg exit'
        bindsym Mod4+Shift+h move left
        bindsym Mod4+Shift+j move down
        bindsym Mod4+Shift+k move up
        bindsym Mod4+Shift+l move right
        bindsym Mod4+Shift+minus move scratchpad
        bindsym Mod4+Shift+p exec ${getExe pkgs.cliphist} list | ${getExe pkgs.fuzzel} --dmenu | ${getExe pkgs.cliphist} decode | ${pkgs.wl-clipboard}/bin/wl-copy
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
        bindsym Mod4+p exec ${getExe pkgs.fuzzel}
        bindsym Mod4+q scratchpad show
        bindsym Mod4+r mode resize
        bindsym Mod4+s layout stacking
        bindsym Mod4+space floating toggle
        bindsym Mod4+t layout tabbed
        bindsym Mod4+v splitv
        bindsym Mod4+w kill
        bindsym Mod4+x exec ${getExe pkgs.wleave}
        bindsym Print exec ${getExe pkgs.grim} -g "$(${getExe pkgs.slurp})" - | ${getExe' pkgs.wl-clipboard "wl-copy"}

        input "type:keyboard" {
          xkb_layout us
          repeat_delay 300
          repeat_rate 30
        }

        input "2:14:SynPS/2_Synaptics_TouchPad" {
          dwt enabled
          middle_emulation enabled
          natural_scroll enabled
          tap enabled
        }

        output "*" {
          bg $HOME/Pictures/Wallpaper/Minato-Aqua-Dark.png fill
        }

        output "HDMI-A-1" {
          mode 1920x1080@180Hz
          pos 0 0
        }

        output "eDP-1" {
          disable
        }

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
          swaybar_command ${pkgs.sway}/bin/swaybar
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
