{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:
let
  inherit (lib)
    getExe
    getExe'
    optionals
    concatLists
    genList
    ;

  cfg = config.mine.hyprland;
  theme = config.mine.theme;
  palette = theme.colorScheme.palette;

  sysPkgs = inputs.ludovico-pkgs.packages.${pkgs.stdenv.hostPlatform.system};

  # --- helpers ---------------------------------------------------------------
  app2unit = if cfg.withUWSM then "${getExe sysPkgs.app2unit} --" else "";
  uwsm = config.programs.uwsm.package;

  fuzzel = getExe pkgs.fuzzel;
  brightnessctl = getExe pkgs.brightnessctl;
  playerctl = getExe pkgs.playerctl;
  wireplumber = getExe' pkgs.wireplumber "wpctl";
  grimblast = getExe pkgs.grimblast;
  swappy = getExe pkgs.swappy;
  wlcopy = getExe' pkgs.wl-clipboard "wl-copy";
  powermenu = getExe pkgs.wleave;

  launch = cmd: "${app2unit} ${cmd}";
  # run = cmd: "exec , ${launch cmd}";

  clipboard = "${getExe pkgs.cliphist} list | ${fuzzel} --dmenu | ${getExe pkgs.cliphist} decode | ${wlcopy}";
  emojiPicker = getExe sysPkgs.fuzzmoji;

  # --- grouped window rules ---------------------------------------------------
  # rule = str: str;
  workspaceRule = num: class: "workspace ${toString num}, class:^(${class})$";

  windowRules =
    let
      # apps grouped by purpose
      browsers = "firefox|floorp|zen-beta|Chromium-browser|chromium-browser";
      ideGames = "jetbrains-(goland|clion)|Albion-Online";
      musicApps = "spotify|org.fooyin.fooyin|tidal-hifi|foobar2000.exe";
      fileDialogs = "xdg-desktop-portal-gtk";
      passwordMgr = "org.keepassxc.KeePassXC";
      steamClass = "steam";

      # specialized rules
      telegramRules = [
        (workspaceRule 4 "org.telegram.desktop")
        "float, title:^(Media viewer)$, class:^(org.telegram.desktop)$"
        "noanim, class:^(org.telegram.desktop)$"
      ];

      discordRules = [
        (workspaceRule 3 "vesktop")
        "workspace 3, title:^(.*(Disc|ArmC|WebC)ord.*)$"
        "noblur, title:^(.*(Disc|WebC)ord.*)$"
        "noblur, title:^(Open File)$"
        "noshadow, title:^(.*(Disc|WebC)ord.*)$"
      ];

      steamRules = [
        (workspaceRule 6 steamClass)
        "workspace 6, title:^(Sign in to Steam)$"
        "float, class:^(steam)$,title:^(Special Offers|Steam - News)$"
        "nofocus, class:^(steam)$,title:^(Steam - News|notificationtoasts_.*_desktop)$"
        "noinitialfocus, class:^(steam)$, title:(^notificationtoasts.*)"
        "nofocus, title:(^notificationtoasts.*)"
      ];

      browserRules = [
        (workspaceRule 2 browsers)
        "noblur, class:^(${browsers})$"
        "noshadow, class:^(${browsers})$"
        "idleinhibit focus, class:^(${browsers})$, title:^(.*YouTube.*)$"
        "idleinhibit fullscreen, class:^(${browsers})$"
      ];

      musicRules = [
        (workspaceRule 5 musicApps)
        "tile, class:^(foobar2000.exe)$"
        "noanim, class:^(foobar2000.exe)$"
      ];

      ideRules = [ (workspaceRule 1 ideGames) ];

      miscRules = [
        "workspace 9, class:^(thunderbird)$"
        "workspace 8, class:^(whatsapp-for-linux)$"
        "workspace 7, class:^(qBittorrent|org.qbittorrent.qBittorrent)$"

        # General behavior fixes
        "suppressevent maximize, class:.*"
        "nofocus,class:^$,title:^$,xwayland:1,floating:1,fullscreen:0,pinned:0"

        # Bitwarden Firefox popup
        "float, title:^(.*Bitwarden Password Manager.*)$"

        # Password dialogs
        "noblur, class:^(${passwordMgr})$"
        "noanim, class:^(${passwordMgr})$"
        "float, class:^(${passwordMgr})$,title:^(Generate Password|KeePassXC - Browser Access Request)$"

        # File chooser dialogs
        "float, class:^(${fileDialogs})$,title:^(Open File(s)?)$"

        # Wleave
        "noanim, class:^(wleave)$"
      ];

      workspaceDecorRules = [
        "bordersize 0, floating:0, onworkspace:w[tv1]s[false]"
        "rounding 0, floating:0, onworkspace:w[tv1]s[false]"
        "bordersize 0, floating:0, onworkspace:f[1]s[false]"
        "rounding 0, floating:0, onworkspace:f[1]s[false]"
        "rounding 5, onworkspace:s[true]"
      ];
    in
    concatLists [
      workspaceDecorRules
      telegramRules
      discordRules
      steamRules
      browserRules
      musicRules
      ideRules
      miscRules
    ];

in
{
  hm.wayland.windowManager.hyprland.settings = {
    exec-once = concatLists [
      [
        "${getExe uwsm} finalize"
        "${brightnessctl} set 10%"
        "[workspace 9 silent;noanim] ${launch (getExe pkgs.thunderbird)}"
        "sleep 1 && ${launch (getExe pkgs.waybar)}"
      ]
      (optionals config.services.desktopManager.gnome.enable [
        "systemctl --user stop xdg-desktop-portal-gnome.service"
      ])
      (optionals config.services.desktopManager.plasma6.enable [
        "systemctl --user stop xdg-desktop-portal-kde.service"
        "systemctl --user stop plasma-xdg-desktop-portal-kde.service"
      ])
    ];

    env = [
      "HYPRCURSOR_THEME,phinger-cursors-light-hyprcursor"
      "HYPRCURSOR_SIZE,${toString theme.gtk.cursorTheme.size}"
      "XCURSOR_THEME,${theme.gtk.cursorTheme.name}"
      "XCURSOR_SIZE,${toString theme.gtk.cursorTheme.size}"
    ];

    monitor = [
      "HDMI-A-1, 1920x1080@144, auto, 1"
      "eDP-1,disable"
    ];

    animations = {
      enabled = true;
      bezier = [
        "easeOutQuint, 0.23, 1, 0.32,1"
        "almostLinear, 0.5, 0.5, 0.75, 1.0"
        "quick, 0.15, 0, 0.1, 1"
      ];
      animation = [
        "windows, 1, 4.79, easeOutQuint"
        "fade, 1, 3.03, quick"
        "workspaces, 1, 1.94, almostLinear, fade"
      ];
    };

    dwindle = {
      force_split = 2;
      pseudotile = true;
      preserve_split = true;
    };

    decoration = {
      rounding = 0;
      blur = {
        enabled = config.vars.opacity < 1;
        size = 2;
        passes = 2;
        vibrancy = 0.4;
        new_optimizations = true;
        ignore_opacity = true;
      };
      shadow.enabled = false;
    };

    general = {
      gaps_in = 3;
      gaps_out = 3;
      border_size = 2;
      "col.active_border" = "rgb(${palette.base0D})";
      "col.inactive_border" = "rgb(${palette.base03})";
      layout = "dwindle";
    };

    group.groupbar = {
      render_titles = false;
      text_color = "rgb(${palette.base05})";
      "col.active" = "rgb(${palette.base0D})";
      "col.inactive" = "rgb(${palette.base03})";
    };

    misc = {
      background_color = "rgb(${palette.base00})";
      disable_splash_rendering = true;
      vfr = true;
    };

    input = {
      kb_layout = "us";
      kb_options = "ctrl:nocaps";
      follow_mouse = 1;
      repeat_rate = 30;
      repeat_delay = 300;
      touchpad.natural_scroll = true;
    };

    layerrule = [
      "blur, notifications"
      "blur, launcher"
      "blur, lockscreen"
      "ignorealpha 0.69, notifications"
      "ignorealpha 0.69, launcher"
      "ignorealpha 0.69, lockscreen"
    ];

    workspace = concatLists [
      [
        "w[tv1]s[false], gapsout:0, gapsin:0"
        "f[1]s[false], gapsout:0, gapsin:0"
        "s[true], gapsout:10, gapsin:10, rounding:true"
      ]
      (genList (i: "${toString (i + 1)}, monitor:HDMI-A-1") 9)
    ];

    windowrule = windowRules;

    "$mod" = "SUPER";

    bind = [
      "$mod SHIFT, C , exit ,"
      "$mod      , Q, togglespecialworkspace"
      "$mod SHIFT, Q, movetoworkspace, special"
      "$mod SHIFT, E , exec , ${launch (getExe pkgs.xfce.thunar)}"
      "$mod      , F , fullscreen , 0"
      "$mod      , M , exec , [workspace 9 silent;tile] ${launch (getExe pkgs.thunderbird)}"
      "$mod      , P , exec , ${fuzzel}"
      "$mod      , O , exec , ${launch clipboard}"
      "$mod SHIFT, O , exec , ${launch emojiPicker}"
      "$mod SHIFT, P , exec , ${launch (getExe' pkgs.pass-wayland "passmenu")}"
      "$mod      , Space , togglefloating ,"
      "$mod      , R , togglegroup ,"
      "$mod SHIFT, J , changegroupactive, f"
      "$mod SHIFT, K , changegroupactive, b"
      "$mod      , W , killactive ,"
      "$mod      , X , exec , ${launch powermenu}"
      "$mod      , Return , exec , ${launch config.vars.terminal}"
      ", print, exec , ${launch "wl-ocr"}"
      "CTRL , Print , exec , ${launch "${grimblast} save area - | ${swappy} -f -"}"
      "ALT , Print , exec , ${launch "${grimblast} --notify --cursor copysave output ~/Pictures/Screenshots/$(date +'%F_%H:%M:%S.png')"}"
    ]
    ++ (genList (i: "$mod , ${toString (i + 1)} , workspace , ${toString (i + 1)}") 9)
    ++ (genList (i: "$mod SHIFT , ${toString (i + 1)} , movetoworkspacesilent , ${toString (i + 1)}") 9)
    ++ optionals config.mine.firefox.enable [ "$mod , G , exec , ${launch "firefox"}" ]
    ++ optionals config.mine.zen-browser.enable [ "$mod SHIFT , G , exec , ${launch "zen-beta"}" ]
    ++ optionals config.mine.vesktop.enable [ "$mod , D , exec , ${launch "vesktop"}" ];

    bindel = [
      ", XF86AudioRaiseVolume , exec , ${wireplumber} set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%+"
      ", XF86AudioLowerVolume , exec , ${wireplumber} set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%-"
      ", XF86MonBrightnessUp  , exec , ${brightnessctl} set 5%+"
      ", XF86MonBrightnessDown, exec , ${brightnessctl} set 5%-"
    ];

    bindl = [
      ", XF86AudioNext , exec , ${playerctl} next"
      ", XF86AudioPrev , exec , ${playerctl} previous"
      ", XF86AudioPlay , exec , ${playerctl} play-pause"
    ];

    bindm = [
      "$mod , mouse:272 , movewindow"
      "$mod , mouse:273 , resizewindow"
    ];

    xwayland.force_zero_scaling = true;
  };
}
