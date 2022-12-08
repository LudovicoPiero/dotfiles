{
  pkgs,
  config,
  ...
}: let
  inherit (config.colorscheme) colors;
in {
  wayland.windowManager.hyprland.extraConfig = ''
    #        name  , resolution  ,offset , scale
    monitor = eDP-1, 1366x768@60 , 0x0   , 1

    $HYPR_FOLDER = /home/$(whoami)/.config/hypr

    input {
        follow_mouse = 1
        repeat_rate = 50
        repeat_delay = 300
        touchpad {
        	natural_scroll = 1
    		disable_while_typing = 1
        }
    }

    general {
        sensitivity = 1
        main_mod = SUPER
        gaps_in = 2
        gaps_out = 2
        border_size = 2
    	   col.active_border = rgb(${colors.base0D})
    	   col.inactive_border = rgb(${colors.base00})
        layout = dwindle
    }

    master {
        new_is_master = true
        new_on_top = true
    }

    decoration {
        rounding = 4
        blur = 1
        blur_size = 8
        blur_passes = 2
        blur_new_optimizations = true

        drop_shadow = false
        shadow_range = 5
        col.shadow = rgb(eba0ac)
        shadow_render_power = 2
        shadow_ignore_window = 1
    }

    animations {
        enabled = 1

        bezier = customBezier , 0.79 , 0.33 , 0.14 , 0.53

        animation = windows , 1 , 3 , customBezier
        animation = border , 1 , 2 , default
        animation = fade , 1 , 2 , default
        animation = workspaces , 1 , 2 , customBezier
    }

    misc {
        disable_hyprland_logo = 1
        disable_splash_rendering = 1
        no_vfr = 0
        disable_autoreload = false
        enable_swallow = 1
        swallow_regex = ^(kitty)$
    }

    dwindle {
         col.group_border_active = rgb(${colors.base0B})
         col.group_border = rgb(${colors.base00})
        pseudotile = 0 # enable pseudotiling on dwindle
    }

    gestures {
        workspace_swipe = 1
    }

    # window rules
    windowrule = float , Steam
    #windowrule = float , ^(kitty)$
    #windowrule = center , ^(kitty)$
    windowrule = animation slidedown , rofi
    windowrule = workspace 4 , Steam
    windowrule = workspace 4 , lutris
    windowrule = workspace 3 , discord
    windowrule = workspace 2 , Chromium
    windowrule = workspace 2 , firefox
    windowrule = workspace 2 , chromium-browser
    windowrule = workspace 2 , librewolf
    windowrule = workspace 4 , Mailspring
    windowrule = workspace 1 , jetbrains-goland

    # v2
    windowrulev2 = tile, class:^(Spotify)$
    windowrulev2 = noblur, class:^(waybar)$
    windowrulev2 = noblur, class:^(firefox)$
    windowrulev2 = noblur, class:^(chromium-browser)$
    windowrulev2 = noblur, class:^(discord)$
    windowrulev2 = noblur, title:^(WebCord)$
    windowrulev2 = workspace 3, title:^(WebCord)$
    windowrulev2 = noblur, title:^(Open File)$
    windowrulev2 = noshadow, class:^(waybar)$
    windowrulev2 = noshadow, class:^(firefox)$
    windowrulev2 = noshadow, class:^(chromium-browser)$
    windowrulev2 = noshadow, class:^(discord)$
    windowrulev2 = workspace 5 , class:^(Spotify)$
    windowrulev2 = workspace 1 , class:^(jetbrains-clion)$
    windowrulev2 = opacity 0.95 , class:^(Code)$ # VSCODE
    windowrulev2 = rounding 0 , class:^(Code)$ # VSCODE

    # Variables
    $discord = discordcanary  --disable-features=UseOzonePlatform --ignore-gpu-blocklist --enable-features=VaapiVideoDecoder --use-gl=desktop --enable-gpu-rasterization --enable-zero-copy
    $menu = $HYPR_FOLDER/scripts/bemenu
    $powermenu = $HYPR_FOLDER/scripts/powermenu

    # Binds Keyboard
    bind = SUPERSHIFT , Return , exec , foot -L tmux
    bind = SUPERSHIFT , G , exec , chromium
    bind = SUPER , C , exit ,
    bind = SUPER , D , exec , $discord
    bind = SUPERSHIFT , D , exec , webcord
    bind = SUPER , E , exec , [float] thunar
    bind = SUPER , F , fullscreen , 0
    bind = SUPER , G , exec , ${pkgs.firefox}/bin/firefox
    bind = SUPER , M , exec , [workspace 5 silent;tile] mailspring
    bind = SUPER , P , exec , $menu
    bind = SUPER , Q , exec , ${pkgs.hyprpicker}/bin/hyprpicker -f hex --autocopy
    bind = SUPER , T , togglefloating ,
    bind = SUPER , S , exec , [workspace 5 silent;tile] spotify
    bind = SUPER , W , killactive ,
    bind = SUPER , X , exec , $powermenu
    bind = SUPER , Return , exec , ${pkgs.kitty}/bin/kitty
    bind = CTRL  , Return , exec , ${pkgs.wezterm}/bin/wezterm

    # Binds Mouse
    bindm = SUPER , mouse:272 , movewindow
    bindm = SUPER , mouse:273 , resizewindow

    # Screenshot
    bind = CTRL , Print , exec , grimblast --notify copysave area
    bind = SUPER , Print , exec , grimblast --notify --cursor copysave output

    #bind = SUPER , h , movefocus , l
    #bind = SUPER , l , movefocus , r
    bind = SUPER , h , resizeactive , -20 0
    bind = SUPER , l , resizeactive , 20 0
    bind = SUPER , k , movefocus , u
    bind = SUPER , j , movefocus , d
    bind = SUPER , k , layoutmsg , cyclenext
    #bind = SUPER , j , layoutmsg , cycleprev
    #bind = ALT , Return , layoutmsg , swapwithmaster

    bind = SUPERSHIFT , h , movewindow , l
    bind = SUPERSHIFT , l , movewindow , r
    bind = SUPERSHIFT , k , movewindow , u
    bind = SUPERSHIFT , j , movewindow , d

    bind = SUPER , 1 , workspace , 1
    bind = SUPER , 2 , workspace , 2
    bind = SUPER , 3 , workspace , 3
    bind = SUPER , 4 , workspace , 4
    bind = SUPER , 5 , workspace , 5
    # bind = SUPER , 6 , workspace , 6
    # bind = SUPER , 7 , workspace , 7
    # bind = SUPER , 8 , workspace , 8
    # bind = SUPER , 9 , workspace , 9
    # bind = SUPER , 0 , workspace , 10

    bind = SUPERSHIFT , 1 , movetoworkspacesilent , 1
    bind = SUPERSHIFT , 2 , movetoworkspacesilent , 2
    bind = SUPERSHIFT , 3 , movetoworkspacesilent , 3
    bind = SUPERSHIFT , 4 , movetoworkspacesilent , 4
    bind = SUPERSHIFT , 5 , movetoworkspacesilent , 5
    # bind = SUPERSHIFT , 6 , movetoworkspacesilent , 6
    # bind = SUPERSHIFT , 7 , movetoworkspacesilent , 7
    # bind = SUPERSHIFT , 8 , movetoworkspacesilent , 8
    # bind = SUPERSHIFT , 9 , movetoworkspacesilent , 9
    # bind = SUPERSHIFT , 0 , movetoworkspacesilent , 10

    # Media Keys
    bind = , XF86AudioNext , exec , ${pkgs.playerctl}/bin/playerctl next
    bind = , XF86AudioPrev , exec , ${pkgs.playerctl}/bin/playerctl previous
    bind = , XF86AudioPlay , exec , ${pkgs.playerctl}/bin/playerctl play-pause
    bind = , XF86AudioPause , exec , ${pkgs.playerctl}/bin/playerctl pause
    bind = , XF86AudioStop , exec , ${pkgs.playerctl}/bin/playerctl stop
    bind = , XF86AudioRaiseVolume , exec , ${pkgs.alsa-utils}/bin/amixer -q set Master 5%+
    bind = , XF86AudioLowerVolume , exec , ${pkgs.alsa-utils}/bin/amixer -q set Master 5%-

    # Brightness Keys
    bind = , XF86MonBrightnessUp , exec , ${pkgs.brightnessctl}/bin/brightnessctl set 5%+
    bind = , XF86MonBrightnessDown , exec , ${pkgs.brightnessctl}/bin/brightnessctl set 5%-

    exec-once = ${pkgs.waybar}/bin/waybar
    # exec-once = eww open bar
    # exec-once = ${pkgs.hyprpaper}/bin/hyprpaper
    exec-once = ${pkgs.mpvpaper}/bin/mpvpaper -o "no-audio --loop-playlist" eDP-1 $HYPR_FOLDER/Wallpaper/Wallpaper.mp4
  '';
}
