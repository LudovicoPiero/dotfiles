{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (config.vars.colorScheme) colors;
  _ = lib.getExe;
  terminal = "${config.vars.terminalBin}";
  launcher = "${_ pkgs.fuzzel}";
  browser = "${_ pkgs.firefox}";
  powermenu = "${_ pkgs.wlogout}";
  swayidle = pkgs.writeShellScriptBin "swayidle-script" ''
    ${_ pkgs.swayidle} -w \
      timeout 300 '${lib.getExe pkgs.swaylock} -f -c 000000' \
      timeout 600 'swaymsg "output * power off"' \
      resume 'swaymsg "output * power on"' \
      before-sleep '${lib.getExe pkgs.swaylock} -f -c 000000'
  '';
  discord-wrapped = "${_ pkgs.discord-canary} --enable-features=UseOzonePlatform --ozone-platform=wayland --enable-accelerated-mjpeg-decode --enable-accelerated-video --ignore-gpu-blacklist --enable-native-gpu-memory-buffers --enable-gpu-rasterization --enable-gpu --enable-features=WebRTCPipeWireCapturer";
  webcord-wrapped = "${_ pkgs.webcord-vencord} --enable-features=UseOzonePlatform --ozone-platform=wayland --enable-accelerated-mjpeg-decode --enable-accelerated-video --ignore-gpu-blacklist --enable-native-gpu-memory-buffers --enable-gpu-rasterization --enable-gpu --enable-features=WebRTCPipeWireCapturer";
in {
  exec-once = [
    "waybar"
    "${lib.getExe swayidle}"
    "sleep 10;systemctl --user restart xdg-desktop-portal xdg-desktop-portal-hyprland xdg-desktop-portal-gtk"
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
    gaps_in = 4;
    gaps_out = 4;
    border_size = 2;
    "col.active_border" = "rgb(1e5799) rgb(f300ff) rgb(e0ff00) 45deg";
    "col.inactive_border" = "rgba(595959aa)";

    layout = "dwindle";
    "col.group_border_active" = "rgb(${colors.base0B})";
    "col.group_border" = "rgb(${colors.base00})";
  };

  dwindle = {
    force_split = 2;
    pseudotile = true;
    preserve_split = true;
  };

  decoration = {
    # See https://wiki.hyprland.org/Configuring/Variables/ for more

    rounding = 5;
    blur = true;
    blur_size = 8;
    blur_passes = 4;
    blur_new_optimizations = true;

    drop_shadow = false;
    shadow_range = 8;
    shadow_render_power = 3;
    shadow_offset = "2 2";
    "col.shadow" = "rgb(f300ff)";
  };

  animations = {
    enabled = true;

    "bezier" = "myBezier, 0.05, 0.9, 0.1, 1.05";
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
    disable_splash_rendering = true;
    vfr = true;
    vrr = 1;
    render_titles_in_groupbar = false;
  };

  windowrulev2 = [
    "workspace 9, class:^(Mailspring)$"
    "workspace 8, class:^(whatsapp-for-linux)$"
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
    "$mod      , C , exit ,"
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
    "$mod      , T , togglefloating ,"
    "$mod      , R , togglegroup ,"
    "$mod SHIFT , J , changegroupactive, f"
    "$mod SHIFT , K , changegroupactive, b"
    "$mod      , S , exec , [workspace 5 silent;tile] spotify"
    "$mod      , W , killactive ,"
    "$mod      , X , exec , ${powermenu}"
    "$mod      , Return , exec , ${terminal}"

    "$mod , E , exec , emacsclient -c -a 'nvim'"
    "ALT   , E , exec , emacsclient -c -eval '(dired nil)'"

    ", print , exec , sharenix --selection"
    "CTRL  , Print , exec , grimblast save area - | ${lib.getExe pkgs.swappy} -f -"
    "$mod , Print , exec , grimblast --notify --cursor copysave output ~/Pictures/Screenshot/$(date +'%s.png')"
    "$modSHIFT , Print , exec , wl-ocr"

    "$mod , h , resizeactive , -20 0"
    "$mod , l , resizeactive , 20 0"
    "$mod , k , movefocus , u"
    "$mod , j , movefocus , d"

    "$mod , left , movewindow , l"
    "$mod , right , movewindow , r"
    "$mod , up , movewindow , u"
    "$mod , down , movewindow , d"

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
