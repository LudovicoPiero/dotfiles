{
  pkgs,
  lib,
  config,
  ...
}:
let
  inherit (lib) mkIf getExe mkOrder;
  inherit (config.mine.theme.colorScheme) palette;

  cfgmine = config.mine;
in
mkIf cfgmine.hyprland.enable {
  hj.xdg.config.files."hypr/hyprland.conf".text = mkOrder 100 ''
    exec-once = uwsm finalize
    exec-once = ${getExe pkgs.brightnessctl} set 10%
    exec-once = [workspace 9 silent;noanim] uwsm app -- ${getExe pkgs.thunderbird}
    exec-once = uwsm app -- ${getExe pkgs.waybar}
    exec-once = uwsm app -- ${getExe pkgs.mako}

    env = HYPRCURSOR_THEME,Phinger Cursors
    env = XCURSOR_THEME,Phinger Cursors
    env = HYPRCURSOR_SIZE,24
    env = XCURSOR_SIZE,24

    decoration {
      dim_inactive = false
      dim_strength = 0.700000
      rounding = 0

      blur {
        enabled = false
        ignore_opacity = true
        new_optimizations = true
        passes = 2
        size = 2
        special = false
        vibrancy = 0.400000
        xray = true
      }

      shadow {
        enabled = false
        range = 8
        render_power = 3
      }
    }

    dwindle {
      force_split = 2
      preserve_split = true
      pseudotile = true
    }

    general {
      border_size = 2
      col.active_border = rgb(${palette.base0D})
      col.inactive_border = rgb(${palette.base02})
      gaps_in = 3
      gaps_out = 3
      layout = dwindle
    }
    group {
      col.border_active = rgb(${palette.base0D})
      col.border_inactive = rgb(${palette.base02})
      groupbar {
        col.active = rgb(${palette.base0D})
        col.inactive = rgb(${palette.base02})
        render_titles = false
        text_color = rgb(${palette.base05})
      }
    }

    input {
      follow_mouse = 1
      kb_layout = us
      kb_options = ctrl:nocaps
      repeat_delay = 300
      repeat_rate = 30

      touchpad {
        disable_while_typing = true
        natural_scroll = true
      }
    }

    misc {
      background_color = rgb(${palette.base00})
      disable_hyprland_logo = false
      disable_splash_rendering = true
      enable_anr_dialog = false
      force_default_wallpaper = -1
    }

    xwayland {
      force_zero_scaling = true
    }
  '';
}
