{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:
let
  inherit (lib) getExe getExe' optionals;
  inherit (config.mine.theme.colorScheme) palette;

  cfg = config.mine.hyprland;
  cfgmine = config.mine;

  app2unit =
    if cfg.withUWSM then
      "${getExe inputs.ludovico-pkgs.packages.${pkgs.stdenv.hostPlatform.system}.app2unit} --"
    else
      "";

  launcher = getExe pkgs.fuzzel;
  powermenu = getExe pkgs.wleave;
  uwsm = config.programs.uwsm.package;
  clipboard = "${getExe pkgs.cliphist} list | ${getExe pkgs.fuzzel} --dmenu | ${getExe pkgs.cliphist} decode | ${getExe' pkgs.wl-clipboard "wl-copy"}";
  emojiPicker = getExe inputs.ludovico-pkgs.packages.${pkgs.stdenv.hostPlatform.system}.fuzzmoji;
in
{
  hm.wayland.windowManager.hyprland.settings = {
    exec-once =
      [
        "${getExe uwsm} finalize"
        "${getExe pkgs.brightnessctl} set 10%"
        "[workspace 9 silent;noanim] ${app2unit} ${getExe pkgs.thunderbird}"
        "sleep 5 && ${app2unit} ${getExe pkgs.waybar}"
      ]
      ++ optionals config.services.desktopManager.gnome.enable [
        "systemctl --user stop xdg-desktop-portal-gnome.service"
      ]
      ++ optionals config.services.desktopManager.plasma6.enable [
        "systemctl --user stop xdg-desktop-portal-kde.service"
        "systemctl --user stop plasma-xdg-desktop-portal-kde.service"
      ];

    env = [
      "HYPRCURSOR_THEME,phinger-cursors-light-hyprcursor"
      "HYPRCURSOR_SIZE,${toString cfgmine.theme.gtk.cursorTheme.size}"
      "XCURSOR_THEME,${cfgmine.theme.gtk.cursorTheme.name}"
      "XCURSOR_SIZE,${toString cfgmine.theme.gtk.cursorTheme.size}"
    ];

    monitor = [
      "HDMI-A-1, 1920x1080@180, auto, 1"
      "eDP-1,disable"
    ];

    animations = {
      enabled = true;

      bezier = [
        "myBezier, 0.05, 0.9, 0.1, 1.05"
        "easeOutQuint, 0.23, 1, 0.32,1"
        "easeInOutCubic, 0.65, 0.05, 0.36, 1"
        "linear, 0, 0, 1, 1"
        "almostLinear, 0.5, 0.5, 0.75, 1.0"
        "quick, 0.15, 0, 0.1, 1"
      ];

      animation = [
        "global, 1, 10, default"
        "border, 1, 5.39, easeOutQuint"
        "windows, 1, 4.79, easeOutQuint"
        "windowsIn, 1, 4.1, easeOutQuint, popin 87%"
        "windowsOut, 1, 1.49, linear, popin 87%"
        "fadeIn, 1, 1.73, almostLinear"
        "fadeOut, 1, 1.46, almostLinear"
        "fade, 1, 3.03, quick"
        "layers, 1, 3.81, easeOutQuint"
        "layersIn, 1, 4, easeOutQuint, fade"
        "layersOut, 1, 1.5, linear, fade"
        "fadeLayersIn, 1, 1.79, almostLinear"
        "fadeLayersOut, 1, 1.39, almostLinear"
        "workspaces, 1, 1.94, almostLinear, fade"
        "workspacesIn, 1, 1.21, almostLinear, fade"
        "workspacesOut, 1, 1.94, almostLinear, fade"
      ];
    };

    dwindle = {
      force_split = 2;
      pseudotile = true;
      preserve_split = true;
    };

    decoration = {
      rounding = 0;
      dim_inactive = false;
      dim_strength = 0.7;

      blur = {
        enabled = config.vars.opacity < 1;
        size = 2;
        passes = 2;
        vibrancy = 0.4;
        new_optimizations = true;
        ignore_opacity = true;
        xray = true;
        special = false;
      };

      shadow = {
        enabled = false;
        range = 8;
        render_power = 3;
      };
    };

    general = {
      gaps_in = 3;
      gaps_out = 3;
      border_size = 2;
      "col.active_border" = "rgb(${palette.base0D})";
      "col.inactive_border" = "rgb(${palette.base03})";
      layout = "dwindle";
    };

    group = {
      groupbar = {
        render_titles = false;
        text_color = "rgb(${palette.base05})";
        "col.active" = "rgb(${palette.base0D})";
        "col.inactive" = "rgb(${palette.base03})";
      };
      "col.border_active" = "rgb(${palette.base0D})";
      "col.border_inactive" = "rgb(${palette.base03})";
    };

    misc = {
      background_color = "rgb(${palette.base00})";
      disable_splash_rendering = true;
      force_default_wallpaper = false;
      vfr = true;
      vrr = 0;
    };

    input = {
      kb_layout = "us";
      kb_options = "ctrl:nocaps";
      follow_mouse = 1;
      repeat_rate = 30;
      repeat_delay = 300;

      touchpad = {
        natural_scroll = true;
        disable_while_typing = true;
      };
    };

    layerrule = [
      "blur, notifications"
      "blur, launcher"
      "blur, lockscreen"
      "ignorealpha 0.69, notifications"
      "ignorealpha 0.69, launcher"
      "ignorealpha 0.69, lockscreen"
    ];

    workspace = [
      "w[tv1]s[false], gapsout:0, gapsin:0"
      "f[1]s[false], gapsout:0, gapsin:0"
      "s[true], gapsout:10, gapsin:10, rounding:true"
    ] ++ (lib.lists.genList (i: "${toString (i + 1)}, monitor:HDMI-A-1") 9);

    windowrule = [
      # General workspace rules
      "bordersize 0, floating:0, onworkspace:w[tv1]s[false]"
      "rounding 0, floating:0, onworkspace:w[tv1]s[false]"
      "bordersize 0, floating:0, onworkspace:f[1]s[false]"
      "rounding 0, floating:0, onworkspace:f[1]s[false]"
      "rounding 5, onworkspace:s[true]" # Set rounding to 5 on special workspace

      # Workspace-specific rules
      "workspace 9, class:^(thunderbird)$"
      "workspace 8, class:^(whatsapp-for-linux)$"
      "workspace 7, class:^(qBittorrent|org.qbittorrent.qBittorrent)$"

      # Ignore maximize requests from apps. You'll probably like this.
      "suppressevent maximize, class:.*"

      # Fix some dragging issues with XWayland
      "nofocus,class:^$,title:^$,xwayland:1,floating:1,fullscreen:0,pinned:0"

      # Bitwarden Firefox Extensions
      "float, title:^(.*Bitwarden Password Manager.*)$"

      # Telegram Media Viewer
      "float, title:^(Media viewer)$, class:^(org.telegram.desktop)$"

      # Steam rules
      "workspace 6, class:^(steam)$"
      "workspace 6, title:^(Sign in to Steam)$"
      "float, class:^(steam)$,title:^(Special Offers)$"
      "float, class:^(steam)$,title:^(Steam - News)$"
      "nofocus, class:^(steam)$,title:^(Steam - News)$"
      "nofocus, class:^(steam)$,title:^(notificationtoasts_.*_desktop)$"
      "noinitialfocus, class:^(steam)$, title:(^notificationtoasts.*)"
      "nofocus, title:(^notificationtoasts.*)"
      "nofocus, class:^(steam)$, title:^()$"

      # Music Player rules
      "workspace 5, class:^(spotify)$, title:^(Spotify( (Premium|Free))?)$"
      "workspace 5, class:(org.fooyin.fooyin)"
      "workspace 5, class:(tidal-hifi)"

      # Telegram rules
      "workspace 4, class:^(org.telegram.desktop)$"

      # Discord and similar applications
      "workspace 3, title:^(.*(Disc|ArmC|WebC)ord.*)$"
      "workspace 3, class:^(vesktop)$"

      # Browsers
      # Firefox / floorp / zen
      "workspace 2, class:^(firefox|floorp|zen-beta)$"
      "noblur, class:^(firefox|floorp|zen-beta)$"
      "noshadow, class:^(firefox|floorp|zen-beta)$"
      "idleinhibit focus, class:^(firefox|floorp|zen-beta)$, title:^(.*YouTube.*)$"
      "idleinhibit fullscreen, class:^(firefox|floorp|zen-beta)$"

      # Foobar2000
      "workspace 5, class:^(foobar2000.exe)$"
      "tile, class:^(foobar2000.exe)$"
      "noanim, class:^(foobar2000.exe)$"

      ## Floorp
      "workspace 2, class:^(floorp)$"
      "noblur, class:^(floorp)$"
      "noshadow, class:^(floorp)$"

      ## Chromium
      "workspace 2, class:^(Chromium-browser)$" # xwayland
      "workspace 2, class:^(chromium-browser)$" # wayland
      "noblur, class:^(Chromium-browser)$" # xwayland
      "noblur, class:^(chromium-browser)$" # wayland
      "noshadow, class:^(Chromium-browser)$" # xwayland
      "noshadow, class:^(chromium-browser)$" # wayland

      # JetBrains IDEs and games
      "workspace 1, class:^(jetbrains-goland)$"
      "workspace 1, class:^(jetbrains-clion)$"
      "workspace 1, class:^(Albion-Online)$"

      # KeepassXC rules
      "noblur, class:^(org.keepassxc.KeePassXC)$"
      "noanim, class:^(org.keepassxc.KeePassXC)$"
      "float, class:^(org.keepassxc.KeePassXC)$,title:^(Generate Password)$"
      "float, class:^(org.keepassxc.KeePassXC)$,title:^(KeePassXC - Browser Access Request)$"

      # Discord/WebCord blur and shadow rules
      "noblur, title:^(.*(Disc|WebC)ord.*)$"
      "noblur, title:^(Open File)$"
      "noshadow, title:^(.*(Disc|WebC)ord.*)$"
      "float, class:^(xdg-desktop-portal-gtk)$,title:^(Open File(s)?)$"

      # Noanim rules
      "noanim, class:^(org.telegram.desktop)$"
      "noanim, class:^(wleave)$"
    ];

    "$mod" = "SUPER";
    bind =
      [
        "$mod SHIFT, C , exit ,"
        "$mod      , Q, togglespecialworkspace"
        "$mod SHIFT, Q, movetoworkspace, special"
        "$mod SHIFT, E , exec , ${app2unit} thunar"
        "$mod      , F , fullscreen , 0"
        "$mod      , M , exec , [workspace 9 silent;tile] ${app2unit}  thunderbird"
        "$mod      , P , exec , ${launcher}"
        "$mod      , O , exec , ${app2unit} ${clipboard}"
        "$mod SHIFT, O , exec , ${app2unit} ${emojiPicker}"
        "$mod SHIFT, P , exec , ${app2unit} ${getExe' pkgs.pass-wayland "passmenu"}"
        "$mod      , Space , togglefloating ,"
        "$mod      , R , togglegroup ,"
        "$mod SHIFT, J , changegroupactive, f"
        "$mod SHIFT, K , changegroupactive, b"
        "$mod      , W , killactive ,"
        "$mod      , X , exec , ${app2unit} ${powermenu}"
        "$mod      , Return , exec , ${app2unit} '${config.vars.terminal}'"

        ", print, exec , ${app2unit}  wl-ocr"
        "CTRL   , Print , exec , ${app2unit} ${getExe pkgs.grimblast} save area - | ${getExe pkgs.swappy} -f -"
        "ALT    , Print , exec , ${app2unit} ${getExe pkgs.grimblast} --notify --cursor copysave output ~/Pictures/Screenshots/$(date +'%F_%H:%M:%S.png')"

        # Dwindle Keybind
        "$mod , h , movefocus , l"
        "$mod , l , movefocus , r"
        "$mod , k , movefocus , u"
        "$mod , j , movefocus , d"

        "$mod , left , movewindow , l"
        "$mod , right , movewindow , r"
        "$mod , up , movewindow , u"
        "$mod , down , movewindow , d"
        "$mod SHIFT , h , movewindow , l"
        "$mod SHIFT , l , movewindow , r"
        "$mod SHIFT , k , movewindow , u"
        "$mod SHIFT , j , movewindow , d"

        "$mod , 1 , workspace , 1"
        "$mod , 2 , workspace , 2"
        "$mod , 3 , workspace , 3"
        "$mod , 4 , workspace , 4"
        "$mod , 5 , workspace , 5"
        "$mod , 6 , workspace , 6"
        "$mod , 7 , workspace , 7"
        "$mod , 8 , workspace , 8"
        "$mod , 9 , workspace , 9"
        "$mod , 0 , workspace , 10"

        "$mod SHIFT , 1 , movetoworkspacesilent , 1"
        "$mod SHIFT , 2 , movetoworkspacesilent , 2"
        "$mod SHIFT , 3 , movetoworkspacesilent , 3"
        "$mod SHIFT , 4 , movetoworkspacesilent , 4"
        "$mod SHIFT , 5 , movetoworkspacesilent , 5"
        "$mod SHIFT , 6 , movetoworkspacesilent , 6"
        "$mod SHIFT , 7 , movetoworkspacesilent , 7"
        "$mod SHIFT , 8 , movetoworkspacesilent , 8"
        "$mod SHIFT , 9 , movetoworkspacesilent , 9"
        "$mod SHIFT , 0 , movetoworkspacesilent , 10"

        ", XF86AudioStop , exec , ${pkgs.playerctl}/bin/playerctl stop"
      ]
      ++ optionals cfgmine.firefox.enable [ "$mod      , G , exec , ${app2unit} firefox" ]
      ++ optionals cfgmine.zen-browser.enable [ "$mod SHIFT, G , exec , ${app2unit} zen-beta" ]
      ++ optionals cfgmine.vesktop.enable [ "$mod      , D , exec , ${app2unit} vesktop" ];

    bindel = [
      ", XF86AudioRaiseVolume  , exec , ${pkgs.wireplumber}/bin/wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%+"
      ", XF86AudioLowerVolume  , exec , ${pkgs.wireplumber}/bin/wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%-"
      ", XF86AudioMute         , exec , ${pkgs.wireplumber}/bin/wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
      ", XF86AudioMicMute      , exec , ${pkgs.wireplumber}/bin/wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
      ", XF86MonBrightnessUp   , exec , ${pkgs.brightnessctl}/bin/brightnessctl -e4 -n2 set 5%+"
      ", XF86MonBrightnessDown , exec , ${pkgs.brightnessctl}/bin/brightnessctl -e4 -n2 set 5%-"
    ];

    bindl = [
      ", XF86AudioNext , exec , ${pkgs.playerctl}/bin/playerctl next"
      ", XF86AudioPrev , exec , ${pkgs.playerctl}/bin/playerctl previous"
      ", XF86AudioPlay , exec , ${pkgs.playerctl}/bin/playerctl play-pause"
      ", XF86AudioPause , exec , ${pkgs.playerctl}/bin/playerctl play-pause"
    ];

    bindm = [
      "$mod , mouse:272 , movewindow"
      "$mod , mouse:273 , resizewindow"
    ];

    xwayland.force_zero_scaling = true;
  };
}
