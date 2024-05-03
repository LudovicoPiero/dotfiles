{
  pkgs,
  lib,
  config,
  ...
}:
let
  inherit (config.colorScheme) palette;
  _ = lib.getExe;
  launcher = "${_ pkgs.fuzzel}";
  powermenu = "${_ pkgs.wlogout}";
  emacs = if config.services.emacs.enable then "emacsclient -c" else "emacs";
in
{
  exec-once =
    [
      "systemctl --user restart xdg-desktop-portal-gtk.service xdg-desktop-portal.service xdg-desktop-portal-hyprland.service swaybg.service"
      "waybar"
      "fcitx5 -d --replace"
      "${_ pkgs.mako}"
      # "swayidle-script"
      "[workspace 9 silent;noanim] ${_ pkgs.thunderbird}"
    ]
    ++ lib.optionals (config.programs.emacs.enable && !config.services.emacs.enable) [
      "${_ config.programs.emacs.finalPackage} --fg-daemon"
    ];

  monitor = [
    ",highrr,auto,1"
    "HDMI-A-1, highrr, auto, 1.5"
  ];

  animations = {
    enabled = true;

    bezier = [ "myBezier, 0.05, 0.9, 0.1, 1.05" ];

    animation = [
      "windows, 1, 7, myBezier"
      "windowsOut, 1, 7, default, popin 80%"
      "windowsMove, 1, 2, default, popin 80%"
      "border, 1, 10, default"
      "borderangle, 1, 8, default"
      "fade, 1, 7, default"
      "workspaces, 1, 6, default"
    ];
  };

  dwindle = {
    force_split = 2;
    pseudotile = true;
    preserve_split = true;
    no_gaps_when_only = 0; # (default: disabled - 0) no border - 1, with border - 2
  };

  decoration = {
    # See https://wiki.hyprland.org/Configuring/Variables/ for more
    rounding = 0;

    dim_inactive = false;
    dim_strength = 0.7;

    blur = {
      enabled = false;
      size = 2;
      passes = 1;
      # contrast = 0.8916;
      # brightness = 0.8172;
      vibrancy = 0.4;
      new_optimizations = true;
      ignore_opacity = true;
      xray = true;
      special = true;
    };

    drop_shadow = false;
    shadow_range = 8;
    shadow_render_power = 3;
    shadow_offset = "2 2";
    "col.shadow" = "rgb(f300ff)";
  };

  general = {
    sensitivity = 1;
    gaps_in = 0;
    gaps_out = 0;
    border_size = 2;
    "col.active_border" = "rgb(${palette.base0E})";
    "col.inactive_border" = "rgb(${palette.base02})";

    layout = "dwindle";
  };

  group = {
    groupbar = {
      render_titles = false;
      "col.active" = "rgb(${palette.base0B})";
      "col.inactive" = "rgb(${palette.base03})";
    };
    "col.border_active" = "rgb(a6e3a1)";
    "col.border_inactive" = "rgb(585b70)";
  };

  input = {
    kb_layout = "us";
    follow_mouse = 1;
    repeat_rate = 30;
    repeat_delay = 300;
    kb_options = "ctrl:nocaps";

    touchpad = {
      natural_scroll = true;
      disable_while_typing = true;
    };
  };

  misc = {
    disable_splash_rendering = true; # Text below the wallpaper
    force_default_wallpaper = false;
    vfr = true;
    vrr = 0;
  };

  layerrule = [
    "blur, notifications"
    "blur, launcher"
    "blur, lockscreen"
    "ignorealpha 0.69, notifications"
    "ignorealpha 0.69, launcher"
    "ignorealpha 0.69, lockscreen"
  ];

  windowrulev2 = [
    "workspace 9, class:^(thunderbird)$"
    "workspace 8, class:^(whatsapp-for-linux)$"
    "workspace 7, class:^(qBittorrent|org.qbittorrent.qBittorrent)$"
    "workspace 6, class:^(steam)$"
    "workspace 6, title:^(Sign in to Steam)$"
    "workspace 5, title:(Spotify)"
    "workspace 4, class:^(org.telegram.desktop)$"
    "workspace 3, title:^(.*(Disc|ArmC|WebC)ord.*)$"
    "workspace 3, class:^(vesktop)$"
    "workspace 2, class:^(firefox)$"
    "workspace 2, class:^(Chromium-browser)$" # xwayland
    "workspace 2, class:^(chromium-browser)$" # wayland
    "workspace 1, class:^(jetbrains-goland)$"
    "workspace 1, class:^(jetbrains-clion)$"
    "workspace 1, class:^(Albion-Online)$"
    "fakefullscreen, class:^(code-url-handler)$"
    "float, class:^(DiscordCanary)$" # Discord File Picker
    "float, title:^(Steam - News)$"
    "float, class:^(electron)$,title:^(Open Files)$"
    "float, class:^(steam)$,title:^(Special Offers)$"
    "noblur, class:^(waybar)$"
    "noblur, class:^(firefox)$"
    "noblur, class:^(Chromium-browser)$" # xwayland
    "noblur, class:^(chromium-browser)$" # wayland
    "noblur, title:^(.*(Disc|WebC)ord.*)$"
    "noblur, title:^(Open File)$"
    "noshadow, class:^(firefox)$"
    "noshadow, class:^(Chromium-browser)$" # xwayland
    "noshadow, class:^(chromium-browser)$" # wayland
    "noshadow, title:^(.*(Disc|WebC)ord.*)$"
    "noanim, class:^(org.telegram.desktop)$"
    "noanim, class:^(wlogout)$"
    "stayfocused, title:^()$,class:^(steam)$"
    "minsize 1 1, title:^()$,class:^(steam)$"
  ];

  "$mod" = "SUPER";
  bind = [
    "$mod SHIFT, C , exit ,"
    "$mod      , Q, togglespecialworkspace"
    "$mod SHIFT, Q, movetoworkspace, special"
    "$mod      , D , exec , run-as-service vesktop"
    "$mod SHIFT, E , exec , run-as-service thunar"
    "$mod      , F , fullscreen , 0"
    "$mod      , G , exec , run-as-service firefox"
    "$mod SHIFT, G , exec , run-as-service chromium"
    "$mod      , M , exec , [workspace 9 silent;tile] thunderbird"
    "$mod      , P , exec , run-as-service ${launcher}"
    "$mod SHIFT, P , exec , run-as-service ${lib.getExe' pkgs.pass-wayland "passmenu"}"
    "$mod      , Space , togglefloating ,"
    "$mod      , R , togglegroup ,"
    "$mod SHIFT, J , changegroupactive, f"
    "$mod SHIFT, K , changegroupactive, b"
    "$mod      , S , exec , run-as-service spotify"
    "$mod      , W , killactive ,"
    "$mod      , X , exec , ${powermenu}"
    "$mod      , Return , exec , run-as-service 'wezterm'"

    "$mod      , E , exec , run-as-service \"${emacs}\""
    "ALT       , E , exec , run-as-service \"emacsclient -c -eval '(dired nil)'\""

    ", print, exec , wl-ocr"
    "CTRL   , Print , exec , ${_ pkgs.grimblast} save area - | ${_ pkgs.swappy} -f -"
    "ALT    , Print , exec , ${_ pkgs.grimblast} --notify --cursor copysave output ~/Pictures/Screenshots/$(date +'%s.png')"

    # Dwindle Keybind
    "$mod , h , resizeactive , -20 0"
    "$mod , l , resizeactive , 20 0"
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

    ", XF86AudioNext , exec , ${pkgs.playerctl}/bin/playerctl next"
    ", XF86AudioPrev , exec , ${pkgs.playerctl}/bin/playerctl previous"
    ", XF86AudioPlay , exec , ${pkgs.playerctl}/bin/playerctl play-pause"
    ", XF86AudioPause , exec , ${pkgs.playerctl}/bin/playerctl pause"
    ", XF86AudioStop , exec , ${pkgs.playerctl}/bin/playerctl stop"
  ];

  binde = [
    ", XF86AudioRaiseVolume , exec , ${pkgs.alsa-utils}/bin/amixer -q set Master 5%+"
    ", XF86AudioLowerVolume , exec , ${pkgs.alsa-utils}/bin/amixer -q set Master 5%-"

    ", XF86MonBrightnessUp , exec , ${pkgs.brightnessctl}/bin/brightnessctl set 5%+"
    ", XF86MonBrightnessDown , exec , ${pkgs.brightnessctl}/bin/brightnessctl set 5%-"
  ];

  bindm = [
    "$mod , mouse:272 , movewindow"
    "$mod , mouse:273 , resizewindow"
  ];

  xwayland.force_zero_scaling = true;
}
