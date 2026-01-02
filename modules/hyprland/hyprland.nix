{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    mkOption
    mkIf
    getExe
    getExe'
    ;
  cfg = config.mine.hyprland;
in
{
  options.mine.hyprland = {
    enable = mkEnableOption "Hyprland compositor";
    package = mkOption {
      type = lib.types.package;
      default = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
      description = "The Hyprland package to install.";
    };
  };

  config = mkIf cfg.enable {
    programs = {
      hyprland = {
        enable = true;
        inherit (cfg) package;
        portalPackage =
          inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
      };
    };
    security.pam.services.hypridle.text = "auth include login";

    environment.systemPackages = with pkgs; [
      swaybg
      mako
      waybar
      brightnessctl
      wireplumber
      libnotify
      polkit_gnome
      wleave
      grim
      slurp
      swappy
      wl-clipboard
      cliphist
      tesseract # Needed for OCR
    ];

    hj.xdg.config.files."hypr/hyprland.conf".text = ''
      # MONITOR CONFIG
      monitor = HDMI-A-1, 1920x1080@180, auto, 1, bitdepth, 10
      monitor = eDP-1, disable

      # ENVIRONMENT VARIABLES
      env = QT_QPA_PLATFORM,wayland;xcb
      env = GDK_BACKEND,wayland,x11,*
      env = XDG_CURRENT_DESKTOP,Hyprland
      env = XDG_SESSION_TYPE,wayland
      env = XDG_SESSION_DESKTOP,Hyprland

      # Theming
      #TODO:
      # env = HYPRCURSOR_THEME,Future-Cyan-Hyprcursor_Theme
      env = XCURSOR_THEME,Future-Cyan-Hyprcursor_Theme
      # env = HYPRCURSOR_SIZE,24
      env = XCURSOR_SIZE,24

      # Input Method
      env = QT_IM_MODULE,fcitx
      env = XMODIFIERS,@im=fcitx
      env = QT_IM_MODULES,"wayland;fcitx"

      # AUTOSTART
      exec-once = hyprctl setcursor Future-Cyan-Hyprcursor_Theme 24
      exec-once = fcitx5 -d --replace
      exec-once = ${getExe pkgs.swaybg} -i $HOME/Pictures/Wallpaper/Minato-Aqua-Dark.png
      exec-once = sleep 1; ${getExe pkgs.waybar}
      exec-once = ${getExe pkgs.brightnessctl} set 10%
      exec-once = ${getExe pkgs.mako}
      exec-once = ${getExe pkgs.emacs} --daemon

      # Clipboard history
      exec-once = ${getExe' pkgs.wl-clipboard "wl-paste"} --type text --watch ${getExe pkgs.cliphist} store
      exec-once = ${getExe' pkgs.wl-clipboard "wl-paste"} --type image --watch ${getExe pkgs.cliphist} store

      # Apps
      exec-once = [workspace 5 silent;noanim] ${getExe pkgs.thunderbird}

      # LOOK & FEEL
      general {
          border_size = 2
          col.active_border = rgb(89b4fa)
          col.inactive_border = rgb(313244)
          gaps_in = 0
          gaps_out = 0
          layout = dwindle
      }

      decoration {
          rounding = 0
          dim_inactive = false
          dim_strength = 0.7
          blur {
              enabled = true
              passes = 2
              size = 2
              new_optimizations = true
              xray = true
              ignore_opacity = true
          }
          shadow {
              enabled = false
          }
      }

      animations {
          enabled = true
          bezier = myBezier, 0.05, 0.9, 0.1, 1.05
          bezier = easeOutQuint, 0.23, 1, 0.32,1
          animation = global, 1, 10, default
          animation = windows, 1, 4.79, easeOutQuint
          animation = windowsIn, 1, 4.1, easeOutQuint, popin 87%
          animation = windowsOut, 1, 1.49, linear, popin 87%
          animation = fade, 1, 3.03, default
          animation = workspaces, 1, 1.94, default, fade
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

      dwindle {
          force_split = 2
          preserve_split = true
          pseudotile = true
      }

      group {
          col.border_active = rgb(89b4fa)
          col.border_inactive = rgb(313244)
          groupbar {
              col.active = rgb(89b4fa)
              col.inactive = rgb(313244)
              render_titles = false
              text_color = rgb(cdd6f4)
          }
      }

      misc {
          background_color = rgb(1e1e2e)
          disable_hyprland_logo = false
          disable_splash_rendering = true
          force_default_wallpaper = -1
      }

      xwayland {
          force_zero_scaling = true
      }
    '';
  };
}
