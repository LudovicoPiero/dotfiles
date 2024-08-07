{
  config,
  pkgs,
  inputs,
  lib,
  ...
}:
{
  wayland.windowManager.sway = {
    enable = true;
    package = pkgs.swayfx;
    checkConfig = false;
    config = {
      keybindings = import ./__keybindings.nix {
        inherit
          lib
          inputs
          config
          pkgs
          ;
      };
      bars = import ./__bars.nix { inherit lib pkgs; };
      window = import ./__windows.nix;
      output = {
        "eDP-1" = {
          mode = "1366x768@60Hz";
        };
        "HDMI-A-1" = {
          mode = "1920x1080@60Hz";
          scale = "1.5";
        };
      };
      input = {
        "type:touchpad" = {
          dwt = "enabled";
          tap = "enabled";
          natural_scroll = "enabled";
        };
        "type:keyboard" = {
          xkb_options = "ctrl:nocaps";
          repeat_delay = "200";
          repeat_rate = "30";
        };
      };
      floating = {
        border = 2;
        titlebar = true;
        criteria = [
          { window_role = "pop-up"; }
          { window_role = "bubble"; }
          { window_role = "dialog"; }
          { window_type = "dialog"; }
          { app_id = "lutris"; }
          { app_id = "thunar"; }
          { app_id = "pavucontrol"; }
          { class = ".*.exe"; } # Wine apps
          { class = "steam_app.*"; } # Steam games
          { class = "^Steam$"; } # Steam itself
        ];
      };
      gaps = {
        inner = 3;
        outer = 3;
      };
      fonts = {
        names = [ "Iosevka q" ];
        size = 10.0;
      };
      startup = [
        {
          command = "systemctl --user import-environment DISPLAY WAYLAND_DISPLAY SWAYSOCK XDG_CURRENT_DESKTOP";
        }
        {
          command = "dbus-update-activation-environment --systemd DISPLAY WAYLAND_DISPLAY SWAYSOCK XDG_CURRENT_DESKTOP";
        }
        { command = "mako"; }
        { command = "swayidle-script"; }
        { command = "fcitx5 -d --replace"; }
        { command = "${lib.getExe pkgs.thunderbird}"; }
        {
          command = "systemctl --user restart swaybg xdg-desktop-portal xdg-desktop-portal-hyprland xdg-desktop-portal-gtk";
        }
      ];
      modifier = "Mod4";
      terminal = "wezterm";
      menu = "${pkgs.fuzzel}/bin/fuzzel";
    };
    extraConfig = ''
      titlebar_border_thickness 1
      title_align center
      titlebar_padding 2

      # SwayFX stuff
      # window corner radius in px
      corner_radius 5
      smart_corner_radius disable

      blur enable
      blur_xray disable
      blur_passes 2
      blur_radius 2

      shadows off
      shadows_on_csd off
      shadow_blur_radius 20
      shadow_color #0000007F

      # inactive window fade amount. 0.0 = no dimming, 1.0 = fully dimmed
      default_dim_inactive 0.0
      dim_inactive_colors.unfocused #000000FF
      dim_inactive_colors.urgent #900000FF

      # Treat Scratchpad as minimized
      scratchpad_minimize disable
    '';
    extraSessionCommands = ''
      export XDG_CURRENT_DESKTOP=sway
      export SDL_VIDEODRIVER=wayland
      export QT_QPA_PLATFORM=wayland
      export QT_WAYLAND_DISABLE_WINDOWDECORATION=1
      export _JAVA_AWT_WM_NONREPARENTING=1
    '';
    wrapperFeatures = {
      base = true;
      gtk = true;
    };
    systemd.enable = true;
  };
}
