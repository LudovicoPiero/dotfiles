{
  pkgs,
  lib,
  config,
  self',
  ...
}:
let
  inherit (lib)
    mkIf
    mkAfter
    getExe
    getExe'
    ;

  cfgmine = config.mine;
in
mkIf cfgmine.hyprland.enable {
  hj.xdg.config.files."hypr/hyprland.conf".text = mkAfter ''
    $mod = SUPER
    bind = $mod SHIFT, C , exit ,
    bind = $mod        , Q, togglespecialworkspace
    bind = $mod SHIFT, Q, movetoworkspace, special
    bind = $mod SHIFT, E , exec , uwsm app -- ${getExe pkgs.xfce.thunar}
    bind = $mod        , F , fullscreen , 0
    bind = $mod        , M , exec , uwsm app -- ${getExe pkgs.thunderbird}
    bind = $mod        , P , exec , uwsm app -- ${getExe pkgs.fuzzel}
    bind = $mod        , O , exec , uwsm app -- clipboard-picker
    bind = $mod SHIFT, O , exec , uwsm app -- ${getExe self'.packages.fuzzmoji}
    bind = $mod SHIFT, P , exec , uwsm app -- ${getExe' pkgs.pass-wayland "passmenu"}
    bind = $mod SHIFT, G , exec , uwsm app -- zen-beta
    bind = $mod        , Space , togglefloating ,
    bind = $mod        , R , togglegroup ,
    bind = $mod SHIFT, J , changegroupactive, f
    bind = $mod SHIFT, K , changegroupactive, b
    bind = $mod        , W , killactive ,
    bind = $mod        , X , exec , uwsm app -- ${getExe pkgs.wleave}
    bind = $mod        , Return , exec , uwsm app -- '${config.vars.terminal}'
    bind = $mod        , D , exec , uwsm app -- ${getExe pkgs.vesktop}
    bind = , print, exec , uwsm app -- wl-ocr
    bind = CTRL   , Print , exec , uwsm app -- ${getExe pkgs.grimblast} save area - | ${getExe pkgs.swappy} -f -
    bind = ALT    , Print , exec , uwsm app -- ${pkgs.writeShellScriptBin "shot" ''
      file="$HOME/Pictures/Screenshots/$(date +'%Y-%m-%d_%H-%M-%S').png"
      ${lib.getExe pkgs.grim} -g "$(${lib.getExe pkgs.slurp})" "$file"
      ${lib.getExe' pkgs.wl-clipboard "wl-copy"} < "$file"
      ${lib.getExe' pkgs.libnotify "notify-send"} "Screenshot taken" "Saved to $file" -i "$file"
    ''}/bin/shot

    bind = $mod , h , movefocus , l
    bind = $mod , l , movefocus , r
    bind = $mod , k , movefocus , u
    bind = $mod , j , movefocus , d
    bind = $mod , left , movewindow , l
    bind = $mod , right , movewindow , r
    bind = $mod , up , movewindow , u
    bind = $mod , down , movewindow , d
    bind = $mod SHIFT , h , movewindow , l
    bind = $mod SHIFT , l , movewindow , r
    bind = $mod SHIFT , k , movewindow , u
    bind = $mod SHIFT , j , movewindow , d
    bind = $mod , 1 , workspace , 1
    bind = $mod , 2 , workspace , 2
    bind = $mod , 3 , workspace , 3
    bind = $mod , 4 , workspace , 4
    bind = $mod , 5 , workspace , 5
    bind = $mod , 6 , workspace , 6
    bind = $mod , 7 , workspace , 7
    bind = $mod , 8 , workspace , 8
    bind = $mod , 9 , workspace , 9
    bind = $mod , 0 , workspace , 10
    bind = $mod SHIFT , 1 , movetoworkspacesilent , 1
    bind = $mod SHIFT , 2 , movetoworkspacesilent , 2
    bind = $mod SHIFT , 3 , movetoworkspacesilent , 3
    bind = $mod SHIFT , 4 , movetoworkspacesilent , 4
    bind = $mod SHIFT , 5 , movetoworkspacesilent , 5
    bind = $mod SHIFT , 6 , movetoworkspacesilent , 6
    bind = $mod SHIFT , 7 , movetoworkspacesilent , 7
    bind = $mod SHIFT , 8 , movetoworkspacesilent , 8
    bind = $mod SHIFT , 9 , movetoworkspacesilent , 9
    bind = $mod SHIFT , 0 , movetoworkspacesilent , 10

    # Volume control
    bindel = , XF86AudioRaiseVolume  , exec , ${getExe' pkgs.wireplumber "wpctl"} set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%+
    bindel = , XF86AudioLowerVolume  , exec , ${getExe' pkgs.wireplumber "wpctl"} set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%-
    bindel = , XF86AudioMute         , exec , ${getExe' pkgs.wireplumber "wpctl"} set-mute @DEFAULT_AUDIO_SINK@ toggle
    bindel = , XF86AudioMicMute      , exec , ${getExe' pkgs.wireplumber "wpctl"} set-mute @DEFAULT_AUDIO_SOURCE@ toggle

    # Brightness control
    bindel = , XF86MonBrightnessUp   , exec , ${getExe pkgs.brightnessctl} -e4 -n2 set 5%+
    bindel = , XF86MonBrightnessDown , exec , ${getExe pkgs.brightnessctl} -e4 -n2 set 5%-

    # Media control
    bindl = , XF86AudioNext , exec , ${getExe pkgs.playerctl} next
    bindl = , XF86AudioPrev , exec , ${getExe pkgs.playerctl} previous
    bindl = , XF86AudioPlay , exec , ${getExe pkgs.playerctl} play-pause
    bindl = , XF86AudioPause , exec , ${getExe pkgs.playerctl} play-pause

    # Mouse bindings
    bindm = $mod , mouse:272 , movewindow
    bindm = $mod , mouse:273 , resizewindow
  '';
}
