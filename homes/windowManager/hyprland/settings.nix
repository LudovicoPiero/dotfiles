{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (config.colorScheme) colors;
  _ = lib.getExe;
  terminal = "${_ pkgs.wezterm}";
  launcher = "${_ pkgs.fuzzel}";
  browser = "${_ pkgs.firefox}";
  powermenu = "${_ pkgs.wlogout}";
  swaylock = pkgs.writeShellScriptBin "swaylock-script" ''
    ${_ pkgs.swaylock-effects} \
    --screenshots \
    --clock \
    --indicator \
    --indicator-radius 100 \
    --indicator-thickness 7 \
    --effect-blur 7x5 \
    --effect-vignette 0.5:0.5 \
    --ring-color bb00cc \
    --key-hl-color 880033 \
    --line-color 00000000 \
    --inside-color 00000088 \
    --separator-color 00000000 \
    --grace 0 \
    --fade-in 0.2 \
    -f
  '';

  swayidle = pkgs.writeShellScriptBin "swayidle-script" ''
    ${_ pkgs.swayidle} -w \
    timeout 300 '${_ swaylock}' \
    timeout 360 'hyprctl dispatch dpms off eDP-1 && hyprctl dispatch dpms off DP-1' \
    resume '
     hyprctl monitors | grep HDMI
     ret=$?

     if [ $ret -eq 0 ]
     then
       hyprctl dispatch dpms on DP-1
     else
       hyprctl dispatch dpms on eDP-1
     fi
     ' \
    before-sleep '${_ swaylock}' \
    lock '${_ swaylock}}'
  '';
  discord-wrapped = "${_ pkgs.discord-canary} --enable-features=UseOzonePlatform --ozone-platform=wayland --enable-accelerated-mjpeg-decode --enable-accelerated-video --ignore-gpu-blacklist --enable-native-gpu-memory-buffers --enable-gpu-rasterization --enable-gpu --enable-features=WebRTCPipeWireCapturer";
  webcord-wrapped = "${_ pkgs.webcord-vencord} --enable-features=UseOzonePlatform --ozone-platform=wayland --enable-accelerated-mjpeg-decode --enable-accelerated-video --ignore-gpu-blacklist --enable-native-gpu-memory-buffers --enable-gpu-rasterization --enable-gpu --enable-features=WebRTCPipeWireCapturer";
in {
  exec-once = [
    "waybar"
    "${lib.getExe swayidle}"
    "sleep 3;systemctl --user restart xdg-desktop-portal xdg-desktop-portal-hyprland xdg-desktop-portal-gtk"
  ];

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

  general = {
    sensitivity = 1;
    gaps_in = 1;
    gaps_out = 1;
    border_size = 2;
    "col.active_border" = "rgb(${colors.base0D}) rgb(${colors.base08}) rgb(${colors.base0A}) 45deg";
    "col.inactive_border" = "rgb(${colors.base01})";

    layout = "hy3";
    "col.group_border_active" = "rgb(${colors.base0B})";
    "col.group_border" = "rgb(${colors.base00})";
  };

  dwindle = {
    force_split = 2;
    pseudotile = true;
    preserve_split = true;
    no_gaps_when_only = 2; #(default: disabled - 0) no border - 1, with border - 2
  };

  decoration = {
    # See https://wiki.hyprland.org/Configuring/Variables/ for more

    rounding = 5;
    blurls = [
      "launcher" # Fuzzel
      "lockscreen"
      "notifications" # Dunst
    ];

    blur = {
      enabled = true;
      size = 5;
      passes = 2;
      contrast = 1.4;
      brightness = 1;
      new_optimizations = true;
      ignore_opacity = true;
    };

    drop_shadow = false;
    shadow_range = 8;
    shadow_render_power = 3;
    shadow_offset = "2 2";
    "col.shadow" = "rgb(f300ff)";
  };

  animations = {
    enabled = true;

    bezier = ["myBezier, 0.05, 0.9, 0.1, 1.05"];

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

  misc = {
    disable_splash_rendering = true; # Text below the wallpaper
    force_hypr_chan = false; # Cute
    vfr = true;
    vrr = 1;
    render_titles_in_groupbar = false;
  };

  windowrulev2 = [
    "workspace 9, class:^(Mailspring)$"
    "workspace 8, class:^(whatsapp-for-linux)$"
    "workspace 7, class:^(qBittorrent)$"
    "workspace 6, class:^(steam)$"
    "workspace 6, title:^(Sign in to Steam)$"
    "workspace 5, title:(Spotify)"
    "workspace 4, class:^(org.telegram.desktop)$"
    "workspace 3, title:^(.*(Disc|WebC)ord.*)$"
    "workspace 2, class:^(firefox)$"
    "workspace 2, class:^(Chromium-browser)$" # xwayland
    "workspace 2, class:^(chromium-browser)$" # wayland
    "workspace 1, class:^(jetbrains-goland)$"
    "workspace 1, class:^(jetbrains-clion)$"
    "workspace 1, class:^(Albion-Online)$"
    "fakefullscreen, class:^(code-url-handler)$"
    "float, class:^(DiscordCanary)$" # Discord File Picker
    "float, title:^(Steam - News)$"
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
  ];

  "$mod" = "SUPER";
  bind = [
    "$mod SHIFT , C , exit ,"
    "$mod      , Q, togglespecialworkspace"
    "$mod SHIFT, Q, movetoworkspace, special"
    "$mod      , D , exec , ${discord-wrapped}"
    "$mod SHIFT, D , exec , ${webcord-wrapped}"
    "$mod SHIFT, E , exec , [float] thunar"
    "$mod      , F , fullscreen , 0"
    "$mod SHIFT, G , exec , chromium"
    "$mod      , G , exec , ${browser}"
    "$mod      , M , exec , [workspace 9 silent;tile] mailspring"
    "$mod      , P , exec , run-as-service ${launcher}"
    "$mod      , Space , togglefloating ,"
    # "$mod SHIFT , J , changegroupactive, f"
    # "$mod SHIFT , K , changegroupactive, b"
    "$mod      , S , exec , [workspace 5 silent;tile] spotify"
    "$mod      , W , killactive ,"
    "$mod      , X , exec , ${powermenu}"
    "$mod      , Return , exec , run-as-service ${terminal}"

    "$mod , E , exec , emacsclient -c -a 'nvim'"
    "ALT   , E , exec , emacsclient -c -eval '(dired nil)'"

    ", print , exec , wl-ocr"
    "CTRL  , Print , exec , grimblast save area - | ${lib.getExe pkgs.swappy} -f -"
    "$mod , Print , exec , sharenix --selection"

    # hy3 Keybinding
    "$mod , c , hy3:makegroup, v, ephemeral"
    "$mod , v , hy3:makegroup, h, ephemeral"
    "$mod , r , hy3:makegroup, tab, ephemeral"

    "$mod , h , hy3:movefocus , left"
    "$mod , l , hy3:movefocus , right"
    "$mod , k , hy3:movefocus , up"
    "$mod , j , hy3:movefocus , down"

    "$mod SHIFT , h , hy3:movewindow , left"
    "$mod SHIFT , l , hy3:movewindow , right"
    "$mod SHIFT , k , hy3:movewindow , up"
    "$mod SHIFT , j , hy3:movewindow , down"
    "$mod , left , hy3:movewindow , l"
    "$mod , right , hy3:movewindow , r"
    "$mod , up , hy3:movewindow , u"
    "$mod , down , hy3:movewindow , d"

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
