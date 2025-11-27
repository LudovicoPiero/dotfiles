{
  lib,
  pkgs,
  config,
  self',
  ...
}:
let
  inherit (lib) getExe mkAfter mkIf;

  cfgmine = config.mine;
  launcher = getExe pkgs.fuzzel;
  powermenu = getExe pkgs.wleave;
  emojiPicker = getExe self'.packages.fuzzmoji;
in
mkIf cfgmine.mangowc.enable {
  hj.xdg.config.files."mango/config.conf".text = mkAfter ''
    # Key Bindings
    # mod keys name: super,ctrl,alt,shift,none

    # reload config
    bind=SUPER,r,reload_config

    # menu and terminal
    bind=SUPER,p,spawn,uwsm app -- ${launcher}
    bind=SUPER,Return,spawn,uwsm app -- ${config.vars.terminal}
    bind=SUPER,o,spawn,uwsm app -- clipboard-picker
    bind=SUPER+SHIFT,o,spawn,uwsm app -- ${emojiPicker}
    bind=SUPER+SHIFT,g,spawn,uwsm app -- zen-beta
    bind=SUPER,d,spawn,uwsm app -- ${getExe pkgs.vesktop}

    # exit
    bind=SUPER,x,spawn,uwsm app -- ${powermenu}
    bind=SUPER,w,killclient,

    # Screenshot
    bind=none,Print,spawn,wl-ocr
    bind=CTRL,Print,spawn,${getExe pkgs.grimblast} save area - | ${getExe pkgs.swappy} -f -
    bind=ALT,Print,spawn,${pkgs.writeShellScriptBin "shot" ''
      file="$HOME/Pictures/Screenshots/$(date +'%Y-%m-%d_%H-%M-%S').png"
      ${lib.getExe pkgs.grim} -g "$(${lib.getExe pkgs.slurp})" "$file"
      ${lib.getExe' pkgs.wl-clipboard "wl-copy"} < "$file"
      ${lib.getExe' pkgs.libnotify "notify-send"} "Screenshot taken" "Saved to $file" -i "$file"
    ''}/bin/shot

    # switch window focus
    bind=SUPER,Tab,focusstack,next
    bind=SUPER,h,focusdir,left
    bind=SUPER,l,focusdir,right
    bind=SUPER,k,focusdir,up
    bind=SUPER,j,focusdir,down

    # swap window
    bind=SUPER+SHIFT,h,exchange_client,left
    bind=SUPER+SHIFT,l,exchange_client,right
    bind=SUPER+SHIFT,k,exchange_client,up
    bind=SUPER+SHIFT,j,exchange_client,down

    # switch window status
    bind=ALT,Tab,toggleoverview,
    bind=SUPER,space,togglefloating,
    bind=SUPER,f,togglefullscreen,
    bind=SUPER,q,toggle_scratchpad

    # switch layout
    bind=SUPER,n,switch_layout

    # tag switch
    bind=SUPER,Left,viewtoleft,0
    # bind=CTRL,Left,viewtoleft_have_client,0
    bind=SUPER,Right,viewtoright,0
    # bind=CTRL,Right,viewtoright_have_client,0
    bind=CTRL+SUPER,Left,tagtoleft,0
    bind=CTRL+SUPER,Right,tagtoright,0

    bind=SUPER,1,view,1,0
    bind=SUPER,2,view,2,0
    bind=SUPER,3,view,3,0
    bind=SUPER,4,view,4,0
    bind=SUPER,5,view,5,0
    bind=SUPER,6,view,6,0
    bind=SUPER,7,view,7,0
    bind=SUPER,8,view,8,0
    bind=SUPER,9,view,9,0

    bind=SUPER+SHIFT,1,tag,1,0
    bind=SUPER+SHIFT,2,tag,2,0
    bind=SUPER+SHIFT,3,tag,3,0
    bind=SUPER+SHIFT,4,tag,4,0
    bind=SUPER+SHIFT,5,tag,5,0
    bind=SUPER+SHIFT,6,tag,6,0
    bind=SUPER+SHIFT,7,tag,7,0
    bind=SUPER+SHIFT,8,tag,8,0
    bind=SUPER+SHIFT,9,tag,9,0

    bind=SUPER+CTRL,1,toggletag,1
    bind=SUPER+CTRL,2,toggletag,2
    bind=SUPER+CTRL,3,toggletag,3
    bind=SUPER+CTRL,4,toggletag,4
    bind=SUPER+CTRL,5,toggletag,5
    bind=SUPER+CTRL,6,toggletag,6
    bind=SUPER+CTRL,7,toggletag,7
    bind=SUPER+CTRL,8,toggletag,8
    bind=SUPER+CTRL,9,toggletag,9

    bind=SUPER+SHIFT+CTRL,1,toggleview,1
    bind=SUPER+SHIFT+CTRL,2,toggleview,2
    bind=SUPER+SHIFT+CTRL,3,toggleview,3
    bind=SUPER+SHIFT+CTRL,4,toggleview,4
    bind=SUPER+SHIFT+CTRL,5,toggleview,5
    bind=SUPER+SHIFT+CTRL,6,toggleview,6
    bind=SUPER+SHIFT+CTRL,7,toggleview,7
    bind=SUPER+SHIFT+CTRL,8,toggleview,8
    bind=SUPER+SHIFT+CTRL,9,toggleview,9

    # Mouse Button Bindings
    # NONE mode key only work in ov mode
    mousebind=SUPER,btn_left,moveresize,curmove
    mousebind=NONE,btn_middle,togglemaximizescreen,0
    mousebind=SUPER,btn_right,moveresize,curresize
    mousebind=NONE,btn_left,toggleoverview,1
    mousebind=NONE,btn_right,killclient,0

    # Axis Bindings
    axisbind=SUPER,UP,viewtoleft_have_client
    axisbind=SUPER,DOWN,viewtoright_have_client

    # layer rule
    layerrule=animation_type_open:zoom,layer_name:rofi
    layerrule=animation_type_close:zoom,layer_name:rofi
  '';
}
