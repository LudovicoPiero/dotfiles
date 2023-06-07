{
  colorscheme,
  pkgs,
  lib,
  config,
  ...
}:
with colorscheme.colors; ''
  #        name  , resolution  ,offset , scale
  monitor = eDP-1, 1366x768@60 , 0x0   , 1

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
      sensitivity = 0.9
      gaps_in = 0
      gaps_out = 0
      border_size = 3
      col.active_border = rgb(${blue}) rgb(${pink}) rgb(${yellow}) 45deg
      col.inactive_border = rgb(${gray})

      layout = dwindle
      col.group_border_active = rgb(${base0B})
      col.group_border        = rgb(${base00})
  }

  dwindle {
      force_split             = 2 # new = right or bottom
      pseudotile              = yes # enable pseudotiling on dwindle
      preserve_split          = yes # you probably want this
  }

  decoration {
      # See https://wiki.hyprland.org/Configuring/Variables/ for more

      rounding = 0
      blur = yes
      blur_size = 10
      blur_passes = 2
      blur_new_optimizations = on

      drop_shadow = no
      shadow_range = 8
      shadow_render_power = 3
      shadow_offset = 2 2
      col.shadow = rgb(${pink})
  }

  animations {
      enabled = true
      #bezier = myBezier , 0.05, 0.9, 0.1, 1.05
      bezier = overshot  , 0.7 , 0.6, 0.1, 1.1
      bezier = linear    , 0.0 , 0.0, 1.0, 1.0

      # animation = NAME,ONOFF,SPEED,CURVE,STYLE
      animation   = windows     , 1, 7,   overshot
      animation   = windowsOut  , 1, 7,   overshot
      animation   = border      , 1, 10,  default
      animation   = borderangle , 1, 100, linear, loop
      animation   = fade        , 1, 7,   default
      animation   = workspaces  , 1, 6,   default
  }

  misc {
      disable_hyprland_logo = true
      disable_splash_rendering = true
      vfr = true
      vrr = 0 # 0 - off, 1 - on, 2 - fullscreen only
      disable_autoreload = false
  }

  gestures {
      workspace_swipe = true
  }

  # v2
  windowrulev2 = workspace 9, class:^(Mailspring)$
  windowrulev2 = workspace 6, class:^(Steam)$
  windowrulev2 = workspace 5, class:^(Spotify)$
  windowrulev2 = workspace 4, class:^(org.telegram.desktop)$
  windowrulev2 = workspace 3, class:^(discord)$
  windowrulev2 = workspace 3, title:^(WebCord)$
  windowrulev2 = workspace 2, class:^(firefox)$
  windowrulev2 = workspace 2, class:^(Chromium-browser)$ # xwayland
  windowrulev2 = workspace 2, class:^(chromium-browser)$ # wayland
  windowrulev2 = workspace 1, class:^(jetbrains-goland)$
  windowrulev2 = workspace 1, class:^(jetbrains-clion)$
  windowrulev2 = workspace 1, class:^(Albion-Online)$
  windowrulev2 = float, class:^(DiscordCanary)$ # Discord File Picker
  windowrulev2 = float, title:^(Steam - News)$
  windowrulev2 = noblur, class:^(waybar)$
  windowrulev2 = noblur, class:^(firefox)$
  windowrulev2 = noblur, class:^(Chromium-browser)$ # xwayland
  windowrulev2 = noblur, class:^(chromium-browser)$ # wayland
  windowrulev2 = noblur, class:^(discordcanary)$
  windowrulev2 = noblur, title:^(WebCord)$
  windowrulev2 = noblur, title:^(Open File)$
  windowrulev2 = noshadow, class:^(firefox)$
  windowrulev2 = noshadow, class:^(Chromium-browser)$ # xwayland
  windowrulev2 = noshadow, class:^(chromium-browser)$ # wayland
  windowrulev2 = noshadow, class:^(discordcanary)$
  windowrulev2 = noanim, class:^(wlogout)$
  windowrulev2 = noanim, class:^(Albion-Online)$
  windowrulev2 = fullscreen, class:^(Albion-Online)$

  # Variables
  $discordOption = --enable-features=UseOzonePlatform --ozone-platform=wayland --enable-accelerated-mjpeg-decode --enable-accelerated-video --ignore-gpu-blacklist --enable-native-gpu-memory-buffers --enable-gpu-rasterization --enable-gpu --enable-features=WebRTCPipeWireCapturer
  $discord = ${lib.getExe pkgs.discord-canary} $discordOption
  $webcord = ${lib.getExe pkgs.webcord-vencord} $discordOption

  # Binds Keyboard
  bind = SUPER      , C , exit ,
  bind = SUPER      , Q, togglespecialworkspace
  bind = SUPERSHIFT , Q, movetoworkspace, special
  bind = SUPER      , D , exec , $discord
  bind = SUPERSHIFT , D , exec , $webcord
  bind = SUPERSHIFT , E , exec , [float] ${lib.getExe pkgs.xfce.thunar}
  bind = SUPER      , F , fullscreen , 0
  bind = SUPERSHIFT , G , exec , ${lib.getExe config.programs.chromium.package};
  bind = SUPER      , G , exec , ${lib.getExe pkgs.firefox}
  bind = SUPER      , M , exec , [workspace 5 silent;tile] ${lib.getExe pkgs.mailspring}
  bind = SUPER      , P , exec , ${lib.getExe pkgs.fuzzel}
  bind = SUPER      , T , togglefloating ,
  bind = SUPER      , R , togglegroup ,
  bind = SUPERSHIFT , J , changegroupactive, f
  bind = SUPERSHIFT , K , changegroupactive, b
  bind = SUPER      , S , exec , [workspace 5 silent;tile] ${lib.getExe config.programs.spicetify.spotifyPackage}
  bind = SUPER      , W , killactive ,
  bind = SUPER      , X , exec , ${lib.getExe pkgs.wlogout}
  bind = SUPER      , Return , exec , ${lib.getExe pkgs.foot}

  # Binds Mouse
  bindm = SUPER , mouse:272 , movewindow
  bindm = SUPER , mouse:273 , resizewindow

  # Screenshot
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
  bind  = , XF86AudioNext , exec , playerctl next
  bind  = , XF86AudioPrev , exec , playerctl previous
  bind  = , XF86AudioPlay , exec , playerctl play-pause
  bind  = , XF86AudioPause , exec , playerctl pause
  bind  = , XF86AudioStop , exec , playerctl stop
  binde = , XF86AudioRaiseVolume , exec , amixer -q set Master 5%+
  binde = , XF86AudioLowerVolume , exec , amixer -q set Master 5%-

  # Brightness Keys
  binde = , XF86MonBrightnessUp , exec , brightnessctl set 5%+
  binde = , XF86MonBrightnessDown , exec , brightnessctl set 5%-

  exec-once = waybar
  exec-once = [workspace 3 silent] $discord
  exec-once = [workspace 4 silent] ${lib.getExe pkgs.tdesktop}
  exec-once = [workspace 9 silent] ${lib.getExe pkgs.mailspring}
  exec-once = systemctl --user restart xdg-desktop-portal xdg-desktop-portal-hyprland
''
