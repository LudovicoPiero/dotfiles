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

  screenshot = pkgs.writeShellScriptBin "screenshot" ''
    DIR="$HOME/Pictures/Screenshots"
    FILE="$DIR/$(date +%Y-%m-%d_%H-%M-%S).png"

    mkdir -p "$DIR"

    # Select area (slurp) -> Capture (grim) -> Save to file
    ${getExe pkgs.grim} -g "$(${getExe pkgs.slurp})" "$FILE"

    # Copy image to clipboard
    ${getExe' pkgs.wl-clipboard "wl-copy"} < "$FILE"

    # Send Notification
    ${getExe pkgs.libnotify} "Screenshot taken" "Saved to $FILE" -i "$FILE"
  '';

  wl-ocr = pkgs.writeShellScriptBin "wl-ocr" ''
    ${getExe pkgs.grim} -g "$(${getExe pkgs.slurp})" - | ${getExe pkgs.tesseract} - - | ${getExe' pkgs.wl-clipboard "wl-copy"}
    ${getExe pkgs.libnotify} "OCR" "Text copied to clipboard"
  '';

  clipboard-picker = pkgs.writeShellScriptBin "clipboard-picker" ''
    ${getExe pkgs.cliphist} list | ${getExe pkgs.rofi} -dmenu display-columns 2 | ${getExe pkgs.cliphist} decode | ${getExe' pkgs.wl-clipboard "wl-copy"}
  '';
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

    security.pam.services.hypridle = {
      text = ''
        auth include login
      '';
    };

    environment.systemPackages = with pkgs; [
      swaybg
      mako
      waybar
      hypridle
      hyprsunset
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
      exec-once = ${getExe pkgs.hypridle}
      exec-once = ${getExe pkgs.swaybg} -i $HOME/Pictures/Wallpaper/Minato-Aqua-Dark.png
      exec-once = ${getExe pkgs.hyprsunset}
      exec-once = sleep 1; ${getExe pkgs.waybar}
      exec-once = ${getExe pkgs.brightnessctl} set 10%
      exec-once = ${getExe pkgs.mako}
      exec-once = ${getExe pkgs.emacs} --daemon

      # Clipboard history
      exec-once = ${getExe' pkgs.wl-clipboard "wl-paste"} --type text --watch ${getExe pkgs.cliphist} store
      exec-once = ${getExe' pkgs.wl-clipboard "wl-paste"} --type image --watch ${getExe pkgs.cliphist} store

      # Apps
      exec-once = [workspace 9 silent;noanim] ${getExe pkgs.thunderbird}

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

      # Workspace Rules
      workspace = w[tv1]s[false], gapsout:0, gapsin:0
      workspace = f[1]s[false], gapsout:0, gapsin:0

      # General
      windowrule = suppress_event maximize, match:class .*
      # "Fix ghost windows" rule
      windowrule = no_focus on, match:class ^$, match:title ^$, match:xwayland 1, match:float 1, match:fullscreen 0, match:pin 0

      # Workspaces
      windowrule = workspace 9, match:class ^(thunderbird|org.mozilla.Thunderbird)$
      windowrule = workspace 8, match:class ^(whatsapp-for-linux)$
      windowrule = workspace 7, match:class ^(qBittorrent|org.qbittorrent.qBittorrent)$

      # Steam
      windowrule = workspace 6, match:class ^(steam)$
      windowrule = workspace 6, match:title ^(Sign in to Steam)$
      windowrule = float on, match:class ^(steam)$, match:title ^(Special Offers)$
      windowrule = float on, match:class ^(steam)$, match:title ^(Steam - News)$
      windowrule = no_initial_focus on, match:class ^(steam)$, match:title ^(Steam - News)$
      windowrule = no_focus on, match:class ^(steam)$, match:title ^(notificationtoasts_.*_desktop)$
      windowrule = no_initial_focus on, match:class ^(steam)$, match:title ^notificationtoasts.*
      windowrule = no_focus on, match:class ^(steam)$, match:title ^$

      # Media
      windowrule = workspace 5, match:class ^(spotify)$
      windowrule = workspace 5, match:class ^(org.fooyin.fooyin)$
      windowrule = workspace 5, match:class ^(tidal-hifi)$
      windowrule = workspace 5, match:class ^(foobar2000.exe)$
      windowrule = tile on, match:class ^(foobar2000.exe)$
      windowrule = no_anim on, match:class ^(foobar2000.exe)$

      # Chat
      windowrule = workspace 4, match:class ^(org.telegram.desktop)$
      windowrule = no_anim on, match:class ^(org.telegram.desktop)$
      windowrule = float on, match:class ^(org.telegram.desktop)$, match:title ^(Media viewer)$

      windowrule = workspace 3, match:title ^(.*(Disc|ArmC|WebC)ord.*)$
      windowrule = no_blur on, match:title ^(.*(Disc|WebC)ord.*)$
      windowrule = no_shadow on, match:title ^(.*(Disc|WebC)ord.*)$
      windowrule = workspace 3, match:class ^(vesktop)$

      # Browsers
      $browsers = ^(brave-browser|firefox|firefox-esr|floorp|zen|zen-beta|Chromium-browser|chromium-browser)$
      windowrule = workspace 2, match:class $browsers
      windowrule = no_blur on, match:class $browsers
      windowrule = no_shadow on, match:class $browsers
      windowrule = idle_inhibit fullscreen, match:class $browsers
      windowrule = idle_inhibit focus, match:class $browsers, match:title ^(.*YouTube.*)$

      # Dev & Games
      windowrule = workspace 1, match:class ^(jetbrains-.*)$
      windowrule = no_blur on, match:class ^(jetbrains-.*)$
      windowrule = no_anim on, match:class ^(jetbrains-.*)$
      windowrule = workspace 1, match:class ^(Albion-Online)$

      # Floating / Misc
      windowrule = float on, match:title ^(Extension: \(Bitwarden Password Manager\))$
      windowrule = no_focus on, match:title ^notificationtoasts.*
      windowrule = float on, match:class ^(xdg-desktop-portal-gtk)$
      windowrule = no_blur on, match:class ^(xdg-desktop-portal-gtk)$

      # KeePassXC
      windowrule = no_blur on, match:class ^(org.keepassxc.KeePassXC)$
      windowrule = no_anim on, match:class ^(org.keepassxc.KeePassXC)$
      windowrule = float on, match:class ^(org.keepassxc.KeePassXC)$, match:title ^(Generate Password)$
      windowrule = float on, match:class ^(org.keepassxc.KeePassXC)$, match:title ^(KeePassXC - Browser Access Request)$

      # KEYBINDINGS
      $mod = SUPER

      # Apps (Using getExe)
      bind = $mod, Return, exec, ${getExe pkgs.${config.mine.vars.terminal}}
      bind = $mod, E, exec, ${getExe' pkgs.emacs "emacsclient"} -c
      bind = $mod SHIFT, E, exec, ${getExe pkgs.thunar}
      bind = $mod, M, exec, ${getExe pkgs.thunderbird}
      bind = $mod, P, exec, ${getExe pkgs.rofi} -show drun
      bind = $mod SHIFT, P, exec, ${getExe pkgs.rofi} -show window
      # bind = $mod, D, exec, ${getExe pkgs.vesktop}
      # bind = $mod, G, exec, ${getExe pkgs.firefox}

      # Custom Scripts
      bind = $mod, O, exec, ${getExe clipboard-picker}

      # Screenshots & OCR
      bind = , print, exec, ${getExe wl-ocr}
      bind = ALT, Print, exec, ${getExe screenshot}
      bind = CTRL, Print, exec, ${getExe pkgs.grimblast} save area - | ${getExe pkgs.swappy} -f -

      # Window Management
      bind = $mod, X, exec, ${getExe pkgs.wleave}
      bind = $mod, W, killactive
      bind = $mod SHIFT, C, exit
      bind = $mod, Q, togglespecialworkspace
      bind = $mod SHIFT, Q, movetoworkspace, special
      bind = $mod, F, fullscreen, 0
      bind = $mod, Space, togglefloating
      bind = $mod, R, togglegroup
      bind = $mod SHIFT, J, changegroupactive, f
      bind = $mod SHIFT, K, changegroupactive, b

      # Focus & Move (Vim)
      bind = $mod, h, movefocus, l
      bind = $mod, l, movefocus, r
      bind = $mod, k, movefocus, u
      bind = $mod, j, movefocus, d

      bind = $mod SHIFT, h, movewindow, l
      bind = $mod SHIFT, l, movewindow, r
      bind = $mod SHIFT, k, movewindow, u
      bind = $mod SHIFT, j, movewindow, d

      # Workspaces
      bind = $mod, 1, workspace, 1
      bind = $mod, 2, workspace, 2
      bind = $mod, 3, workspace, 3
      bind = $mod, 4, workspace, 4
      bind = $mod, 5, workspace, 5
      bind = $mod, 6, workspace, 6
      bind = $mod, 7, workspace, 7
      bind = $mod, 8, workspace, 8
      bind = $mod, 9, workspace, 9
      bind = $mod, 0, workspace, 10

      bind = $mod SHIFT, 1, movetoworkspacesilent, 1
      bind = $mod SHIFT, 2, movetoworkspacesilent, 2
      bind = $mod SHIFT, 3, movetoworkspacesilent, 3
      bind = $mod SHIFT, 4, movetoworkspacesilent, 4
      bind = $mod SHIFT, 5, movetoworkspacesilent, 5
      bind = $mod SHIFT, 6, movetoworkspacesilent, 6
      bind = $mod SHIFT, 7, movetoworkspacesilent, 7
      bind = $mod SHIFT, 8, movetoworkspacesilent, 8
      bind = $mod SHIFT, 9, movetoworkspacesilent, 9
      bind = $mod SHIFT, 0, movetoworkspacesilent, 10

      # Media Keys
      bindel = , XF86AudioRaiseVolume, exec, ${getExe' pkgs.wireplumber "wpctl"} set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%+
      bindel = , XF86AudioLowerVolume, exec, ${getExe' pkgs.wireplumber "wpctl"} set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%-
      bindel = , XF86AudioMute, exec, ${getExe' pkgs.wireplumber "wpctl"} set-mute @DEFAULT_AUDIO_SINK@ toggle
      bindel = , XF86MonBrightnessUp, exec, ${getExe pkgs.brightnessctl} -e4 -n2 set 5%+
      bindel = , XF86MonBrightnessDown, exec, ${getExe pkgs.brightnessctl} -e4 -n2 set 5%-
      bindl = , XF86AudioPlay, exec, ${getExe pkgs.playerctl} play-pause
      bindl = , XF86AudioNext, exec, ${getExe pkgs.playerctl} next
      bindl = , XF86AudioPrev, exec, ${getExe pkgs.playerctl} previous

      # Mouse
      bindm = $mod, mouse:272, movewindow
      bindm = $mod, mouse:273, resizewindow
    '';
  };
}
