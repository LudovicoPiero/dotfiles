{
  config,
  lib,
  pkgs,
  inputs',
  ...
}:
let
  inherit (lib)
    mkOption
    types
    mkIf
    getExe
    getExe'
    ;
  cfg = config.mine.niri;
  c = config.mine.theme.colors;

  clipboard-picker = pkgs.writeShellScriptBin "clipboard-picker" ''
    #!/usr/bin/env bash
    cliphist list | rofi -dmenu -display-columns 2 | cliphist decode | wl-copy
  '';
in
{
  options.mine.niri = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable Niri configuration.";
    };

    package = mkOption {
      type = lib.types.package;
      default = inputs'.niri.packages.niri-unstable;
      description = "The niri package to install.";
    };
  };

  config = mkIf cfg.enable {
    programs.niri = {
      enable = true;
      inherit (cfg) package;
    };
    security.pam.services.swaylock.text = "auth include login";

    mine.waybar = {
      enable = true;
      wm = "niri";
    };

    hj.xdg.config.files."niri/config.kdl".text = ''
      config-notification {
          disable-failed
      }

      spawn-at-startup "${getExe' pkgs.dbus "dbus-update-activation-environment"}" "--systemd" "WAYLAND_DISPLAY" "XDG_CURRENT_DESKTOP"

      spawn-sh-at-startup "${getExe pkgs.fcitx5} -d --replace"
      spawn-at-startup "${getExe pkgs.hypridle}"

      spawn-sh-at-startup "${getExe' pkgs.wl-clipboard "wl-paste"} --type text --watch ${getExe pkgs.cliphist} store"
      spawn-sh-at-startup "${getExe' pkgs.wl-clipboard "wl-paste"} --type image --watch ${getExe pkgs.cliphist} store"

      spawn-sh-at-startup "${getExe pkgs.swaybg} -i $HOME/Pictures/Wallpaper/Minato-Aqua-Dark.png"
      spawn-at-startup "${getExe pkgs.waybar}"
      spawn-at-startup "${getExe pkgs.mako}"
      spawn-sh-at-startup "${getExe pkgs.brightnessctl} set 10%"

      spawn-at-startup "${getExe pkgs.thunderbird}"

      spawn-at-startup "${getExe pkgs.swayidle}" "-w" \
          "timeout" "300" "${getExe pkgs.swaylock} -f -c 000000" \
          "timeout" "600" "niri msg action power-off-monitors" \
          "before-sleep" "${getExe pkgs.swaylock} -f -c 000000"

      spawn-sh-at-startup "niri msg action focus-workspace main"

      prefer-no-csd
      screenshot-path "~/Pictures/Screenshots/Screenshot from %Y-%m-%d %H-%M-%S.png"

      hotkey-overlay {
          skip-at-startup
      }

      gestures {
          hot-corners {
              off
          }
      }

      debug {
          honor-xdg-activation-with-invalid-serial
      }

      input {
          focus-follows-mouse

          keyboard {
              repeat-delay 300
              repeat-rate 30
              numlock
              xkb {
                  layout "us"
                  options "ctrl:nocaps"
              }
          }

          touchpad {
              tap
              natural-scroll
              dwt
          }
      }

      output "eDP-1" {
          off
      }

      output "HDMI-A-1" {
          mode "1920x1080@179.998"
          scale 1.0
          variable-refresh-rate
          focus-at-startup
      }

      layout {
          gaps 4
          background-color "transparent"
          center-focused-column "never"
          always-center-single-column

          default-column-width { proportion 0.5; }

          preset-column-widths {
              proportion 0.33333
              proportion 0.5
              proportion 0.66667
          }

          focus-ring {
              width 2
              active-color "${c.base0D}"
              inactive-color "${c.base02}"
          }

          border {
              off
              width 2
              active-color "${c.base0D}"
              inactive-color "${c.base02}"
          }

          shadow {
              softness 30
              spread 5
              offset x=0 y=5
              color "#0007"
          }
      }

      animations {
          workspace-switch {
              spring damping-ratio=0.80 stiffness=523 epsilon=0.0001
          }
          window-open {
              duration-ms 150
              curve "ease-out-expo"
          }
          window-close {
              duration-ms 150
              curve "ease-out-quad"
          }
          horizontal-view-movement {
              spring damping-ratio=0.85 stiffness=423 epsilon=0.0001
          }
          window-movement {
              spring damping-ratio=0.75 stiffness=323 epsilon=0.0001
          }
          window-resize {
              spring damping-ratio=0.85 stiffness=423 epsilon=0.0001
          }
          config-notification-open-close {
              spring damping-ratio=0.65 stiffness=923 epsilon=0.001
          }
          screenshot-ui-open {
              duration-ms 200
              curve "ease-out-quad"
          }
          overview-open-close {
              spring damping-ratio=0.85 stiffness=800 epsilon=0.0001
          }
      }

      environment {
          XDG_CURRENT_DESKTOP "niri"
          QT_QPA_PLATFORM "wayland;xcb"
          GDK_BACKEND "wayland,x11,*"
      }

      cursor {
          hide-when-typing
          hide-after-inactive-ms 1000
      }

      overview {
          workspace-shadow {
              off
          }
      }

      xwayland-satellite {
          path "${getExe pkgs.xwayland-satellite}"
      }

      // === Window rules ===

      // Global: rounded corners, no border background
      window-rule {
          geometry-corner-radius 12
          clip-to-geometry true
          draw-border-with-background false
      }

      // GNOME apps: border drawn around window, not behind
      window-rule {
          match app-id=r#"^org\.gnome\."#
          draw-border-with-background false
          geometry-corner-radius 12
          clip-to-geometry true
      }

      // Tiled windows
      window-rule {
          match is-floating=false
      }

      // Apps that should open floating
      window-rule {
          match app-id=r#"^gnome-calculator$"#
          match app-id=r#"^galculator$"#
          match app-id=r#"^blueman-manager$"#
          match app-id=r#"^org\.gnome\.Nautilus$"#
          match app-id=r#"^xdg-desktop-portal$"#
          open-floating true
      }

      // Apps that should NOT open floating despite being in the above category
      window-rule {
          match app-id=r#"^gnome-control-center$"#
          match app-id=r#"^pavucontrol$"#
          match app-id=r#"^nm-connection-editor$"#
          default-column-width { proportion 0.5; }
          open-floating false
      }

      // Named workspace assignments
      workspace "main"
      workspace "zen"
      workspace "browser"
      workspace "chat"
      workspace "mail"

      window-rule {
          match app-id=r#"(?i)(firefox|firefox-esr|floorp)"#
          open-on-workspace "browser"
          default-column-width { proportion 1.0; }
      }

      window-rule {
          match app-id=r#"(?i)(zen|zen-browser|zen-beta|chromium|brave)"#
          open-on-workspace "zen"
          default-column-width { proportion 1.0; }
      }

      window-rule {
          match app-id=r#"(?i)(discord|vesktop|webcord|slack|telegram|element)"#
          open-on-workspace "chat"
          default-column-width { proportion 1.0; }
      }

      window-rule {
          match app-id=r#"(?i)(thunderbird|mailspring|geary|evolution|kmail)"#
          open-on-workspace "mail"
          default-column-width { proportion 1.0; }
      }

      // Floating overrides
      window-rule {
          match title="Picture-in-Picture"
          open-floating true
      }

      window-rule {
          match app-id=r#"firefox$"# title="^Picture-in-Picture$"
          match app-id="zoom"
          open-floating true
      }

      window-rule {
          match app-id="steam" title=r#"^notificationtoasts_\d+_desktop$"#
          default-floating-position x=10 y=10 relative-to="bottom-right"
      }

      window-rule {
          match app-id="steam" title="Special Offers"
          open-floating true
      }

      window-rule {
          match app-id="steam" title="Steam - News"
          open-floating true
      }

      window-rule {
          match title="Extension: (Bitwarden Password Manager)"
          open-floating true
      }

      window-rule {
          match app-id="xdg-desktop-portal-gtk"
          open-floating true
      }

      window-rule {
          match app-id="org.keepassxc.KeePassXC" title="Generate Password"
          open-floating true
      }

      window-rule {
          match app-id=r#"org\.quickshell$"#
          open-floating true
      }

      // Terminal/browser: no border background
      window-rule {
          match app-id=r#"^org\.wezfurlong\.wezterm$"#
          match app-id="Alacritty"
          match app-id="zen-browser"
          match app-id="com.mitchellh.ghostty"
          match app-id="kitty"
          draw-border-with-background false
      }

      // WezTerm: let it decide its own initial width
      window-rule {
          match app-id=r#"^org\.wezfurlong\.wezterm$"#
          default-column-width {}
      }

      // Layer rules
      layer-rule {
          match namespace="^quickshell$"
          place-within-backdrop true
      }

      // Alt-tab / recent windows
      recent-windows {
          binds {
              Alt+Tab         { next-window scope="output"; }
              Alt+Shift+Tab   { previous-window scope="output"; }
              Alt+grave       { next-window filter="app-id"; }
              Alt+Shift+grave { previous-window filter="app-id"; }
          }
      }

      binds {
          Mod+Shift+Slash { show-hotkey-overlay; }

          Mod+Return repeat=false { spawn "${
            getExe pkgs.${config.mine.vars.terminal}
          }"; }
          Mod+E repeat=false { spawn "emacsclient" "-c"; }
          Mod+M repeat=false { spawn "${getExe pkgs.thunderbird}"; }
          Mod+P repeat=false { spawn "${getExe pkgs.rofi}" "-show" "drun"; }
          Mod+o repeat=false { spawn-sh "${getExe clipboard-picker}"; }
          Mod+X { spawn "${getExe pkgs.wleave}"; }

          // === WORKSPACE NAVIGATION ===
          Mod+1 { focus-workspace 1; }
          Mod+2 { focus-workspace 2; }
          Mod+3 { focus-workspace 3; }
          Mod+4 { focus-workspace 4; }
          Mod+5 { focus-workspace 5; }
          Mod+I { focus-workspace-up; }
          Mod+Page_Up { focus-workspace-up; }
          Mod+U { focus-workspace-down; }
          Mod+Page_Down { focus-workspace-down; }
          Mod+WheelScrollUp cooldown-ms=150 { focus-workspace-up; }
          Mod+WheelScrollDown cooldown-ms=150 { focus-workspace-down; }
          Mod+Shift+1 { move-column-to-workspace 1; }
          Mod+Shift+2 { move-column-to-workspace 2; }
          Mod+Shift+3 { move-column-to-workspace 3; }
          Mod+Shift+4 { move-column-to-workspace 4; }
          Mod+Shift+5 { move-column-to-workspace 5; }
          Mod+Shift+I { move-workspace-up; }
          Mod+Shift+Page_Up { move-workspace-up; }
          Mod+Shift+U { move-workspace-down; }
          Mod+Shift+Page_Down { move-workspace-down; }
          Mod+Ctrl+I { move-column-to-workspace-up; }
          Mod+Ctrl+Up { move-column-to-workspace-up; }
          Mod+Ctrl+U { move-column-to-workspace-down; }
          Mod+Ctrl+Down { move-column-to-workspace-down; }
          Mod+Ctrl+WheelScrollUp cooldown-ms=150 { move-column-to-workspace-up; }
          Mod+Ctrl+WheelScrollDown cooldown-ms=150 { move-column-to-workspace-down; }

          // === FOCUS ===
          Mod+H { focus-column-left; }
          Mod+Left { focus-column-left; }
          Mod+L { focus-column-right; }
          Mod+Right { focus-column-right; }
          Mod+J { focus-window-down; }
          Mod+Down { focus-window-down; }
          Mod+K { focus-window-up; }
          Mod+Up { focus-window-up; }
          Mod+Home { focus-column-first; }
          Mod+End { focus-column-last; }
          Mod+Ctrl+H { focus-monitor-left; }
          Mod+Ctrl+Left { focus-monitor-left; }
          Mod+Ctrl+L { focus-monitor-right; }
          Mod+Ctrl+Right { focus-monitor-right; }
          Mod+Ctrl+J { focus-monitor-down; }
          Mod+Ctrl+K { focus-monitor-up; }
          Mod+WheelScrollLeft { focus-column-left; }
          Mod+WheelScrollRight { focus-column-right; }
          Mod+Shift+WheelScrollUp { focus-column-left; }
          Mod+Shift+WheelScrollDown { focus-column-right; }

          // === MOVE WINDOWS & COLUMNS ===
          Mod+Shift+H { move-column-left; }
          Mod+Shift+Left { move-column-left; }
          Mod+Shift+L { move-column-right; }
          Mod+Shift+Right { move-column-right; }
          Mod+Shift+J { move-window-down; }
          Mod+Shift+Down { move-window-down; }
          Mod+Shift+K { move-window-up; }
          Mod+Shift+Up { move-window-up; }
          Mod+Ctrl+End { move-column-to-last; }
          Mod+Ctrl+Home { move-column-to-first; }
          Mod+Shift+Ctrl+H { move-column-to-monitor-left; }
          Mod+Shift+Ctrl+Left { move-column-to-monitor-left; }
          Mod+Shift+Ctrl+L { move-column-to-monitor-right; }
          Mod+Shift+Ctrl+Right { move-column-to-monitor-right; }
          Mod+Shift+Ctrl+J { move-column-to-monitor-down; }
          Mod+Shift+Ctrl+Down { move-column-to-monitor-down; }
          Mod+Shift+Ctrl+K { move-column-to-monitor-up; }
          Mod+Shift+Ctrl+Up { move-column-to-monitor-up; }
          Mod+Ctrl+Shift+WheelScrollUp { move-column-left; }
          Mod+Ctrl+Shift+WheelScrollDown { move-column-right; }
          Mod+Ctrl+WheelScrollLeft { move-column-left; }
          Mod+Ctrl+WheelScrollRight { move-column-right; }

          // === LAYOUT & COLUMNS ===
          Mod+F { maximize-column; }
          Mod+Shift+F { fullscreen-window; }
          Mod+C { center-column; }
          Mod+Ctrl+C { center-visible-columns; }
          Mod+R { switch-preset-column-width; }
          Mod+Ctrl+F { expand-column-to-available-width; }
          Mod+Shift+R { switch-preset-window-height; }
          Mod+Ctrl+R { reset-window-height; }
          Mod+BracketLeft { consume-or-expel-window-left; }
          Mod+BracketRight { consume-or-expel-window-right; }
          Mod+Period { expel-window-from-column; }
          Super+Q { toggle-column-tabbed-display; }

          // === RESIZE ===
          Mod+Equal { set-column-width "+10%"; }
          Mod+Minus { set-column-width "-10%"; }
          Mod+Shift+Equal { set-window-height "+10%"; }
          Mod+Shift+Minus { set-window-height "-10%"; }

          // === FLOATING & OVERVIEW ===
          Mod+Shift+T { toggle-window-floating; }
          Mod+Shift+V { switch-focus-between-floating-and-tiling; }
          Mod+D repeat=false { toggle-overview; }
          Mod+Tab repeat=false { toggle-overview; }

          // === SCREENSHOTS ===
          Print { screenshot; }
          XF86Launch1 { screenshot; }
          Ctrl+Print { screenshot-screen; }
          Ctrl+XF86Launch1 { screenshot-screen; }
          Alt+Print { screenshot-window; }
          Alt+XF86Launch1 { screenshot-window; }

          // === SYSTEM & MISC ===
          Super+W { close-window; }
          Mod+Shift+E { quit; }
          Mod+Shift+P { power-off-monitors; }
          Mod+Escape { toggle-keyboard-shortcuts-inhibit; }

          // === MEDIA ===
          XF86AudioRaiseVolume allow-when-locked=true { spawn "${getExe' pkgs.wireplumber "wpctl"}" "set-volume" "-l" "1.5" "@DEFAULT_AUDIO_SINK@" "5+%"; }
          XF86AudioLowerVolume allow-when-locked=true { spawn "${getExe' pkgs.wireplumber "wpctl"}" "set-volume" "-l" "1.5" "@DEFAULT_AUDIO_SINK@" "5-%"; }
          XF86AudioMute        allow-when-locked=true { spawn "${getExe' pkgs.wireplumber "wpctl"}" "set-mute" "@DEFAULT_AUDIO_SINK@" "toggle"; }
          XF86AudioMicMute     allow-when-locked=true { spawn "${getExe' pkgs.wireplumber "wpctl"}" "set-mute" "@DEFAULT_AUDIO_SOURCE@" "toggle"; }
          XF86AudioPlay  allow-when-locked=true { spawn "${getExe pkgs.playerctl}" "play-pause"; }
          XF86AudioPause allow-when-locked=true { spawn "${getExe pkgs.playerctl}" "play-pause"; }
          XF86AudioNext  allow-when-locked=true { spawn "${getExe pkgs.playerctl}" "next"; }
          XF86AudioPrev  allow-when-locked=true { spawn "${getExe pkgs.playerctl}" "previous"; }
          XF86MonBrightnessUp   allow-when-locked=true { spawn "${getExe pkgs.brightnessctl}" "set" "5%+"; }
          XF86MonBrightnessDown allow-when-locked=true { spawn "${getExe pkgs.brightnessctl}" "set" "5%-"; }
      }
    '';
  };
}
