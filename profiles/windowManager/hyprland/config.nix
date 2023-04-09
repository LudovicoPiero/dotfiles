{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (config.vars.colorScheme) colors;
  terminal = "${lib.getExe pkgs.kitty}";
  launcher = "${lib.getExe pkgs.fuzzel}";
  browser = "${lib.getExe pkgs.firefox}";
  powermenu = "${lib.getExe pkgs.wlogout}";
in ''
  #        name  , resolution  ,offset , scale
  #monitor = eDP-1, 1366x768@60 , 0x0   , 1
  monitor=,preferred,auto,auto

  $HYPR_FOLDER = /home/$(whoami)/.config/hypr

  input {
      kb_layout = us
      kb_options = ctrl:nocaps
      follow_mouse = 1
      repeat_rate  = 30
      repeat_delay = 300
      touchpad {
          natural_scroll       = true
          disable_while_typing = true
      }
  }

  general {
      sensitivity         = 1
      gaps_in = 4
      gaps_out = 4
      border_size = 2
      col.active_border = rgb(1e5799) rgb(f300ff) rgb(e0ff00) 45deg
      col.inactive_border = rgba(595959aa)

      layout = dwindle
      col.group_border_active = rgb(${colors.base0B})
      col.group_border        = rgb(${colors.base00})
  }

  dwindle {
      force_split             = 2 # new = right or bottom
      pseudotile              = yes # enable pseudotiling on dwindle
      preserve_split          = yes # you probably want this
  }

  decoration {
      # See https://wiki.hyprland.org/Configuring/Variables/ for more

      rounding = 5
      blur = yes
      blur_size = 3
      blur_passes = 1
      blur_new_optimizations = on

      drop_shadow = no
      shadow_range = 8
      shadow_render_power = 3
      shadow_offset = 2 2
      col.shadow = rgb(f300ff)
  }

  animations {
      enabled = true
      # animation=NAME,ONOFF,SPEED,CURVE,STYLE
      bezier = myBezier, 0.05, 0.9, 0.1, 1.05

      animation = windows, 1, 7, myBezier
      animation = windowsOut, 1, 7, default, popin 80%
      animation = windowsMove, 1, 2, default, popin 80%
      animation = border, 1, 10, default
      animation = borderangle, 1, 8, default
      animation = fade, 1, 7, default
      animation = workspaces, 1, 6, default
  }

  misc {
      disable_hyprland_logo = true
      disable_splash_rendering = true
      vfr = 1
      vrr = 2 # 0 - off, 1 - on, 2 - fullscreen only
      disable_autoreload = false
  }

  gestures {
      workspace_swipe = true
  }

  # v2
  windowrulev2 = workspace 5, class:^(Spotify)$
  windowrulev2 = workspace 4, class:^(Steam)$
  windowrulev2 = workspace 3, class:^(discord)$
  windowrulev2 = workspace 3, title:^(WebCord)$
  windowrulev2 = workspace 2, class:^(firefox)$
  windowrulev2 = workspace 2, class:^(chromium-browser)$
  windowrulev2 = workspace 1, class:^(jetbrains-goland)$
  windowrulev2 = workspace 1, class:^(jetbrains-clion)$
  windowrulev2 = workspace 1, class:^(Albion-Online)$
  windowrulev2 = float, class:^(DiscordCanary)$ # Discord File Picker
  windowrulev2 = float, title:^(Steam - News)$
  windowrulev2 = noblur, class:^(waybar)$
  windowrulev2 = noblur, class:^(firefox)$
  windowrulev2 = noblur, class:^(chromium-browser)$
  windowrulev2 = noblur, class:^(discordcanary)$
  windowrulev2 = noblur, title:^(WebCord)$
  windowrulev2 = noblur, title:^(Open File)$
  windowrulev2 = noshadow, class:^(firefox)$
  windowrulev2 = noshadow, class:^(chromium-browser)$
  windowrulev2 = noshadow, class:^(discordcanary)$
  windowrulev2 = noanim, class:^(wlogout)$
  windowrulev2 = noanim, class:^(Albion-Online)$
  windowrulev2 = fullscreen, class:^(Albion-Online)$

  # Variables
  $discordOption = --enable-features=UseOzonePlatform --ozone-platform=wayland --enable-accelerated-mjpeg-decode --enable-accelerated-video --ignore-gpu-blacklist --enable-native-gpu-memory-buffers --enable-gpu-rasterization --enable-gpu --enable-features=WebRTCPipeWireCapturer
  $discord = discordcanary $discordOption
  $webcord = webcord $discordOption

  # Binds Keyboard
  bind = SUPER      , C , exit ,
  bind = SUPER      , Q, togglespecialworkspace
  bind = SUPERSHIFT , Q, movetoworkspace, special
  bind = SUPER      , D , exec , $discord
  bind = SUPERSHIFT , D , exec , $webcord
  bind = SUPERSHIFT , E , exec , [float] thunar
  bind = SUPER      , F , fullscreen , 0
  bind = SUPERSHIFT , G , exec , chromium
  bind = SUPER      , G , exec , ${browser}
  bind = SUPER      , M , exec , [workspace 5 silent;tile] mailspring
  bind = SUPER      , P , exec , ${launcher}
  bind = SUPER      , T , togglefloating ,
  bind = SUPER      , R , togglegroup ,
  bind = SUPERSHIFT , J , changegroupactive, f
  bind = SUPERSHIFT , K , changegroupactive, b
  bind = SUPER      , S , exec , [workspace 5 silent;tile] spotify
  bind = SUPER      , W , killactive ,
  bind = SUPER      , X , exec , ${powermenu}
  bind = SUPER      , Return , exec , ${terminal}

  # EMACS
  bind = SUPER , E , exec , emacsclient -c -a 'nvim'
  bind = ALT   , E , exec , emacsclient -c -eval '(dired nil)'

  # Binds Mouse
  bindm = SUPER , mouse:272 , movewindow
  bindm = SUPER , mouse:273 , resizewindow

  # Screenshot
  bind = , print , exec , sharenix --selection
  bind = CTRL  , Print , exec , grimblast --notify copy area
  bind = SUPER , Print , exec , grimblast --notify --cursor copysave output ~/Pictures/Screenshots/$(date +'%s.png')
  bind = SUPERSHIFT , Print , exec , wl-ocr

  bind = SUPER , h , resizeactive , -20 0
  bind = SUPER , l , resizeactive , 20 0
  bind = SUPER , k , movefocus , u
  bind = SUPER , j , movefocus , d

  bind = SUPER , left , movewindow , l
  bind = SUPER , right , movewindow , r
  bind = SUPER , up , movewindow , u
  bind = SUPER , down , movewindow , d

  bind = SUPER , 1 , workspace , 1
  bind = SUPER , 2 , workspace , 2
  bind = SUPER , 3 , workspace , 3
  bind = SUPER , 4 , workspace , 4
  bind = SUPER , 5 , workspace , 5
  bind = SUPER , 6 , workspace , 6
  bind = SUPER , 7 , workspace , 7
  bind = SUPER , 8 , workspace , 8
  bind = SUPER , 9 , workspace , 9
  bind = SUPER , 0 , workspace , 10

  bind = SUPERSHIFT , 1 , movetoworkspacesilent , 1
  bind = SUPERSHIFT , 2 , movetoworkspacesilent , 2
  bind = SUPERSHIFT , 3 , movetoworkspacesilent , 3
  bind = SUPERSHIFT , 4 , movetoworkspacesilent , 4
  bind = SUPERSHIFT , 5 , movetoworkspacesilent , 5
  bind = SUPERSHIFT , 6 , movetoworkspacesilent , 6
  bind = SUPERSHIFT , 7 , movetoworkspacesilent , 7
  bind = SUPERSHIFT , 8 , movetoworkspacesilent , 8
  bind = SUPERSHIFT , 9 , movetoworkspacesilent , 9
  bind = SUPERSHIFT , 0 , movetoworkspacesilent , 10

  # Media Keys
  bind  = , XF86AudioNext , exec , ${pkgs.playerctl}/bin/playerctl next
  bind  = , XF86AudioPrev , exec , ${pkgs.playerctl}/bin/playerctl previous
  bind  = , XF86AudioPlay , exec , ${pkgs.playerctl}/bin/playerctl play-pause
  bind  = , XF86AudioPause , exec , ${pkgs.playerctl}/bin/playerctl pause
  bind  = , XF86AudioStop , exec , ${pkgs.playerctl}/bin/playerctl stop
  binde = , XF86AudioRaiseVolume , exec , ${pkgs.alsa-utils}/bin/amixer -q set Master 5%+
  binde = , XF86AudioLowerVolume , exec , ${pkgs.alsa-utils}/bin/amixer -q set Master 5%-

  # Brightness Keys
  binde = , XF86MonBrightnessUp , exec , ${pkgs.brightnessctl}/bin/brightnessctl set 5%+
  binde = , XF86MonBrightnessDown , exec , ${pkgs.brightnessctl}/bin/brightnessctl set 5%-

  exec-once = waybar
  exec-once = systemctl --user restart xdg-desktop-portal xdg-desktop-portal-hyprland xdg-desktop-portal-gtk
''
