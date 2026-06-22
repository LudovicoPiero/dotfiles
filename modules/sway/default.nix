_: {
  imports = [ ./window-rules.nix ];
  hm =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      cfg = config.wayland.windowManager.sway;
    in
    {
      wayland.windowManager.sway = {
        enable = true;
        checkConfig = false;

        config = {
          # Runtime Environment Variables
          modifier = "Mod4";
          left = "h";
          down = "j";
          up = "k";
          right = "l";
          terminal = "${pkgs.ghostty}/bin/ghostty";
          menu = "${pkgs.fuzzel}/bin/fuzzel";

          # Fonts Configuration
          fonts = {
            names = [ "JetBrains Mono" ];
            size = 10.0;
          };

          # Color Palette Configuration
          colors = {
            background = "#1e1e2e";
            focused = {
              border = "#cba6f7";
              background = "#cba6f7";
              text = "#1e1e2e";
              indicator = "#cba6f7";
              childBorder = "#cba6f7";
            };
            focusedInactive = {
              border = "#181825";
              background = "#181825";
              text = "#cdd6f4";
              indicator = "#181825";
              childBorder = "#181825";
            };
            unfocused = {
              border = "#181825";
              background = "#181825";
              text = "#cdd6f4";
              indicator = "#181825";
              childBorder = "#181825";
            };
            urgent = {
              border = "#f38ba8";
              background = "#f38ba8";
              text = "#1e1e2e";
              indicator = "#f38ba8";
              childBorder = "#f38ba8";
            };
          };

          # Background Services & Startup Daemons
          startup = [
            { command = "${pkgs.mako}/bin/mako"; }
            {
              command = "${pkgs.wl-clipboard}/bin/wl-paste --type text --watch cliphist store";
            }
            {
              command = "${pkgs.wl-clipboard}/bin/wl-paste --type image --watch cliphist store";
            }
            {
              command = ''
                ${pkgs.swayidle}/bin/swayidle -w \
                  timeout 300 '${pkgs.swaylock}/bin/swaylock -f -c 000000' \
                  timeout 600 'swaymsg "output * power off"' resume 'swaymsg "output * power on"' \
                  before-sleep '${pkgs.swaylock}/bin/swaylock -f -c 000000'
              '';
            }
          ];

          # Hardware & Output Displays
          output = {
            "eDP-1" = {
              disable = "";
            };
            "HDMI-A-1" = {
              mode = "1920x1080@144Hz";
              pos = "0 0";
            };
            "*" = {
              bg = "$HOME/Pictures/Wallpaper/Minato-Aqua-Dark.png fill";
            };
          };

          # Input Profiles Configuration
          input = {
            "2:14:SynPS/2_Synaptics_TouchPad" = {
              dwt = "enabled";
              tap = "enabled";
              natural_scroll = "enabled";
              middle_emulation = "enabled";
            };
            "type:keyboard" = {
              xkb_layout = "us";
            };
          };

          # Key Bindings Layout
          keybindings = lib.mkOptionDefault {
            # Action Essentials
            "${cfg.config.modifier}+Return" = "exec ${cfg.config.terminal}";
            "${cfg.config.modifier}+w" = "kill";
            "${cfg.config.modifier}+p" = "exec ${cfg.config.menu}";
            "${cfg.config.modifier}+Shift+p" =
              "exec cliphist list | ${pkgs.fuzzel}/bin/fuzzel --dmenu | cliphist decode | ${pkgs.wl-clipboard}/bin/wl-copy";
            "${cfg.config.modifier}+Shift+c" = "reload";
            "${cfg.config.modifier}+Shift+e" =
              "exec swaynag -t warning -m 'You pressed the exit shortcut. Do you really want to exit sway? This will end your Wayland session.' -B 'Yes, exit sway' 'swaymsg exit'";

            # Workspace Switching Focus
            "${cfg.config.modifier}+${cfg.config.left}" = "focus left";
            "${cfg.config.modifier}+${cfg.config.down}" = "focus down";
            "${cfg.config.modifier}+${cfg.config.up}" = "focus up";
            "${cfg.config.modifier}+${cfg.config.right}" = "focus right";

            # Container Migration Dispatch
            "${cfg.config.modifier}+Shift+${cfg.config.left}" = "move left";
            "${cfg.config.modifier}+Shift+${cfg.config.down}" = "move down";
            "${cfg.config.modifier}+Shift+${cfg.config.up}" = "move up";
            "${cfg.config.modifier}+Shift+${cfg.config.right}" = "move right";

            # Workspace Navigation
            "${cfg.config.modifier}+1" = "workspace number 1";
            "${cfg.config.modifier}+2" = "workspace number 2";
            "${cfg.config.modifier}+3" = "workspace number 3";
            "${cfg.config.modifier}+4" = "workspace number 4";
            "${cfg.config.modifier}+5" = "workspace number 5";

            # Container Workspace Assignment
            "${cfg.config.modifier}+Shift+1" = "move container to workspace number 1";
            "${cfg.config.modifier}+Shift+2" = "move container to workspace number 2";
            "${cfg.config.modifier}+Shift+3" = "move container to workspace number 3";
            "${cfg.config.modifier}+Shift+4" = "move container to workspace number 4";
            "${cfg.config.modifier}+Shift+5" = "move container to workspace number 5";

            # Layout Structuring Modifiers
            "${cfg.config.modifier}+b" = "splith";
            "${cfg.config.modifier}+v" = "splitv";
            "${cfg.config.modifier}+s" = "layout stacking";
            "${cfg.config.modifier}+t" = "layout tabbed";
            "${cfg.config.modifier}+e" = "layout toggle split";
            "${cfg.config.modifier}+f" = "fullscreen";
            "${cfg.config.modifier}+space" = "floating toggle";
            "${cfg.config.modifier}+Shift+space" = "focus mode_toggle";
            "${cfg.config.modifier}+a" = "focus parent";

            # Scratchpad Control Layer
            "${cfg.config.modifier}+Shift+q" = "move scratchpad";
            "${cfg.config.modifier}+q" = "scratchpad show";

            # Hardware & Media Keys
            "--locked XF86AudioMute" =
              "exec ${pkgs.alsa-utils}/bin/pactl set-sink-mute @DEFAULT_SINK@ toggle";
            "--locked XF86AudioLowerVolume" =
              "exec ${pkgs.alsa-utils}/bin/pactl set-sink-volume @DEFAULT_SINK@ -5%";
            "--locked XF86AudioRaiseVolume" =
              "exec ${pkgs.alsa-utils}/bin/pactl set-sink-volume @DEFAULT_SINK@ +5%";
            "--locked XF86AudioMicMute" =
              "exec ${pkgs.alsa-utils}/bin/pactl set-source-mute @DEFAULT_SOURCE@ toggle";
            "--locked XF86MonBrightnessDown" =
              "exec ${pkgs.brightnessctl}/bin/brightnessctl set 5%-";
            "--locked XF86MonBrightnessUp" =
              "exec ${pkgs.brightnessctl}/bin/brightnessctl set 5%+";
            "Print" =
              "exec ${pkgs.grim}/bin/grim -g \"$(${pkgs.slurp}/bin/slurp)\" - | ${pkgs.wl-clipboard}/bin/wl-copy";

            # Mode Trigger
            "${cfg.config.modifier}+r" = "mode resize";
          };

          # Component Layout Modes
          modes = {
            resize = {
              "${cfg.config.left}" = "resize shrink width 10px";
              "${cfg.config.down}" = "resize grow height 10px";
              "${cfg.config.up}" = "resize shrink height 10px";
              "${cfg.config.right}" = "resize grow width 10px";
              "Left" = "resize shrink width 10px";
              "Down" = "resize grow height 10px";
              "Up" = "resize shrink height 10px";
              "Right" = "resize grow width 10px";
              "Return" = "mode default";
              "Escape" = "mode default";
            };
          };

          # Status Bar Layer
          bars = [
            {
              position = "bottom";
              statusCommand = "${pkgs.i3status}/bin/i3status -c ~/.config/i3status/i3status.conf";
              fonts = {
                names = [ "JetBrains Mono" ];
                size = 10.0;
              };
              colors = {
                statusline = "#cdd6f4";
                background = "#1e1e2e";
                focusedWorkspace = {
                  border = "#cba6f7";
                  background = "#cba6f7";
                  text = "#11111b";
                };
                activeWorkspace = {
                  border = "#89b4fa";
                  background = "#89b4fa";
                  text = "#11111b";
                };
                inactiveWorkspace = {
                  border = "#181825";
                  background = "#181825";
                  text = "#a6adc8";
                };
                urgentWorkspace = {
                  border = "#f38ba8";
                  background = "#f38ba8";
                  text = "#11111b";
                };
              };
            }
          ];
        };
      };
    };
}
