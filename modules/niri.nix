{
  config,
  lib,
  pkgs,
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
      type = types.package;
      default = pkgs.niri;
      description = "The Niri package to install.";
    };
  };

  config = mkIf cfg.enable {
    hj.packages = [ cfg.package ];

    security.pam.services.swaylock = {
      text = ''
        auth include login
      '';
    };

    hj.xdg.config.files."niri/config.kdl".text = ''
      // Env vars
      spawn-at-startup "${getExe' pkgs.dbus "dbus-update-activation-environment"}" "--systemd" "WAYLAND_DISPLAY" "XDG_CURRENT_DESKTOP"

      spawn-at-startup "${getExe pkgs.fcitx5}" "-d" "--replace"
      spawn-at-startup "${getExe pkgs.hypridle}"

      // Clipboard
      spawn-at-startup "${getExe' pkgs.wl-clipboard "wl-paste"}" "--type" "text" "--watch" "${getExe pkgs.cliphist}" "store"
      spawn-at-startup "${getExe' pkgs.wl-clipboard "wl-paste"}" "--type" "image" "--watch" "${getExe pkgs.cliphist}" "store"

      // UI & Wallpaper
      spawn-sh-at-startup "${getExe pkgs.swaybg} -i $HOME/Pictures/Wallpaper/Minato-Aqua-Dark.png"
      spawn-at-startup "${getExe pkgs.waybar}"
      spawn-at-startup "${getExe pkgs.mako}"
      spawn-at-startup "${getExe pkgs.brightnessctl}" "set" "10%"

      // Applications
      spawn-at-startup "${getExe pkgs.thunderbird}"

      spawn-at-startup "${getExe pkgs.swayidle}" "-w" \
          "timeout" "300" "${getExe pkgs.swaylock} -f -c 000000" \
          "timeout" "600" "niri msg action power-off-monitors" \
          "before-sleep" "${getExe pkgs.swaylock} -f -c 000000"

      spawn-at-startup "niri" "msg" "action" "focus-workspace" "main"

      prefer-no-csd
      screenshot-path "~/Pictures/Screenshots/Screenshot from %Y-%m-%d %H-%M-%S.png"

      // Input configuration
      input {
          focus-follows-mouse

          keyboard {
              repeat-delay 300
              repeat-rate 30
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

      // Monitor Configuration
      output "eDP-1" {
          off
      }

      output "HDMI-A-1" {
          mode "1920x1080@179.998"
          scale 1.0
          variable-refresh-rate
      }

      layout {
          gaps 0
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
              active-color "#7aa2f7"
              inactive-color "#292e42"
          }

          border {
              // off
              width 2
              active-color "#7aa2f7"
              inactive-color "#292e42"
          }

          shadow {
              off
          }
      }

      environment {
          QT_QPA_PLATFORM "wayland;xcb"
          GDK_BACKEND "wayland,x11,*"
      }

      cursor {
        // xcursor-theme "phinger-cursors-light"
        // xcursor-size 24
        hide-when-typing
        hide-after-inactive-ms 1000
      }

      overview {
          workspace-shadow {
              off
              softness 40
              spread 10
              offset x=0 y=10
              color "#00000050"
          }
      }

      xwayland-satellite {
        // off
        // path "/usr/bin/xwayland-satellite"
        path "${getExe pkgs.xwayland-satellite}"
      }

      window-rule {
          match is-floating=false
      }

      workspace "main"
      workspace "chat"
      workspace "mail"

      // Chat Workspace
      window-rule {
          match app-id=r#"(?i)(discord|vesktop|webcord|slack|telegram|element)"#
          open-on-workspace "chat"
          default-column-width { proportion 1.0; }
      }

      // Mail Workspace
      window-rule {
          match app-id=r#"(?i)(thunderbird|mailspring|geary|evolution|kmail)"#
          open-on-workspace "mail"
          default-column-width { proportion 1.0; }
      }

      // Floating Rules
      window-rule {
          match title="Picture-in-Picture"
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
          match app-id=r#"^org\.wezfurlong\.wezterm$"#
          default-column-width {}
      }

      binds {
          Mod+Shift+Slash { show-hotkey-overlay; }

          // -- Apps --
          Mod+Return repeat=false { spawn "${
            getExe pkgs.${config.mine.vars.terminal}
          }"; }
          Mod+E repeat=false { spawn "emacsclient" "-c"; }
          Mod+Shift+E repeat=false { spawn "${getExe pkgs.thunar}"; }
          Mod+M repeat=false { spawn "${getExe pkgs.thunderbird}"; }
          Mod+P repeat=false { spawn "${getExe pkgs.rofi}" "-show" "drun"; }
          Mod+o repeat=false { spawn-sh "${getExe clipboard-picker}"; }
          Mod+Shift+P repeat=false { spawn "${getExe pkgs.rofi}" "-show" "window"; }
          Mod+D repeat=false { spawn "${getExe pkgs.vesktop}"; }

          // -- Utils --
          // Mod+Shift+O repeat=false { spawn "${getExe pkgs.rofi}" "-show" "emoji"; }

          // -- Screenshot --
          Print { screenshot-screen; }
          Ctrl+Print { screenshot; }
          Alt+Print { screenshot-window; }

          // -- Window Management --
          Mod+X { spawn "${getExe pkgs.wleave}"; }
          Mod+W { close-window; }
          Mod+Shift+C { quit; }
          Mod+Space { toggle-window-floating; }
          Mod+F { maximize-column; }
          Mod+Shift+F { fullscreen-window; }
          Mod+R { toggle-column-tabbed-display; }

          // -- Focus --
          Mod+H { focus-column-left; }
          Mod+L { focus-column-right; }
          Mod+K { focus-window-up; }
          Mod+J { focus-window-down; }

          // -- Move --
          Mod+Shift+H { move-column-left; }
          Mod+Shift+L { move-column-right; }
          Mod+Shift+K { move-window-up; }
          Mod+Shift+J { move-window-down; }

          // -- Workspaces --
          Mod+1 { focus-workspace "main"; }
          Mod+2 { focus-workspace "chat"; }
          Mod+3 { focus-workspace "mail"; }

          // Move to workspace
          Mod+Shift+1 { move-column-to-workspace "main"; }
          Mod+Shift+2 { move-column-to-workspace "chat"; }
          Mod+Shift+3 { move-column-to-workspace "mail"; }

          // -- Audio & Media --
          XF86AudioRaiseVolume allow-when-locked=true { spawn "${getExe' pkgs.wireplumber "wpctl"}" "set-volume" "-l" "1.5" "@DEFAULT_AUDIO_SINK@" "5%+"; }
          XF86AudioLowerVolume allow-when-locked=true { spawn "${getExe' pkgs.wireplumber "wpctl"}" "set-volume" "-l" "1.5" "@DEFAULT_AUDIO_SINK@" "5%-"; }
          XF86AudioMute        allow-when-locked=true { spawn "${getExe' pkgs.wireplumber "wpctl"}" "set-mute" "@DEFAULT_AUDIO_SINK@" "toggle"; }
          XF86AudioMicMute     allow-when-locked=true { spawn "${getExe' pkgs.wireplumber "wpctl"}" "set-mute" "@DEFAULT_AUDIO_SOURCE@" "toggle"; }

          XF86MonBrightnessUp   allow-when-locked=true { spawn "${getExe pkgs.brightnessctl}" "-e4" "-n2" "set" "5%+"; }
          XF86MonBrightnessDown allow-when-locked=true { spawn "${getExe pkgs.brightnessctl}" "-e4" "-n2" "set" "5%-"; }

          XF86AudioPlay allow-when-locked=true { spawn "${getExe pkgs.playerctl}" "play-pause"; }
          XF86AudioPause allow-when-locked=true { spawn "${getExe pkgs.playerctl}" "play-pause"; }
          XF86AudioNext allow-when-locked=true { spawn "${getExe pkgs.playerctl}" "next"; }
          XF86AudioPrev allow-when-locked=true { spawn "${getExe pkgs.playerctl}" "previous"; }

          // -- Niri Specifics --
          Mod+WheelScrollDown      cooldown-ms=150 { focus-column-right; }
          Mod+WheelScrollUp        cooldown-ms=150 { focus-column-left; }
          Mod+Ctrl+WheelScrollDown cooldown-ms=150 { move-column-to-workspace-down; }
          Mod+Ctrl+WheelScrollUp   cooldown-ms=150 { move-column-to-workspace-up; }
          Mod+Minus { set-column-width "-10%"; }
          Mod+Equal { set-column-width "+10%"; }
          Mod+V       { toggle-window-floating; }
          Mod+Shift+V { switch-focus-between-floating-and-tiling; }
      }
    '';
  };
}
