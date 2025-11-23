{
  config,
  pkgs,
  lib,
  self',
  ...
}:
let
  cfg = config.mine.mangowc;
  cfgmine = config.mine;
  inherit (config.mine.theme.colorScheme) palette;
  inherit (lib) getExe getExe' mkIf;

  launcher = getExe pkgs.fuzzel;
  powermenu = getExe pkgs.wleave;
  clipboard = "${getExe pkgs.cliphist} list | ${getExe pkgs.fuzzel} --dmenu | ${getExe pkgs.cliphist} decode | ${getExe' pkgs.wl-clipboard "wl-copy"}";
  emojiPicker = getExe self'.packages.fuzzmoji;
in
mkIf cfgmine.mangowc.enable {
  hj = {
    packages = [ cfg.package ];
    xdg.config.files."mango/config.conf".text = ''
      # More option see https://github.com/DreamMaoMao/mango/wiki/

      # Monitor rules
      monitorrule=HDMI-A-1,0.55,1,tile,0,1,0,0,1920,1080,180
      monitorrule=eDP-1,0.55,1,tile,0,1,1920,0,1366,768,60

      # Environment Variables
      env=XCURSOR_THEME,${cfgmine.theme.cursor.name}
      env=XCURSOR_SIZE,${toString cfgmine.theme.cursor.size}
      env=GTK_IM_MODULE,fcitx
      env=QT_IM_MODULE,fcitx
      env=SDL_IM_MODULE,fcitx
      env=XMODIFIERS,@im=fcitx
      env=GLFW_IM_MODULE,ibus

      # Startup Applications
      exec-once=uwsm finalize
      exec-once=systemctl --user start xdg-desktop-portal-hyprland.service
      exec-once=${getExe pkgs.brightnessctl} set 10%
      exec-once=uwsm app -- ${getExe pkgs.thunderbird}
      exec-once=uwsm app -- ${getExe pkgs.waybar}
      exec-once=uwsm app -- ${getExe pkgs.mako}

      # Window effect
      blur=0
      blur_layer=0
      blur_optimized=1
      blur_params_num_passes = 2
      blur_params_radius = 5
      blur_params_noise = 0.02
      blur_params_brightness = 0.9
      blur_params_contrast = 0.9
      blur_params_saturation = 1.2

      shadows = 0
      layer_shadows = 0
      shadow_only_floating = 1
      shadows_size = 10
      shadows_blur = 15
      shadows_position_x = 0
      shadows_position_y = 0
      shadowscolor= 0x${palette.base03}ff

      border_radius=3
      no_radius_when_single=0
      focused_opacity=1.0
      unfocused_opacity=1.0

      # Animation Configuration(support type:zoom,slide)
      # tag_animation_direction: 0-horizontal,1-vertical
      animations=1
      layer_animations=1
      animation_type_open=slide
      animation_type_close=slide
      animation_fade_in=1
      animation_fade_out=1
      tag_animation_direction=1
      zoom_initial_ratio=0.3
      zoom_end_ratio=0.8
      fadein_begin_opacity=0.5
      fadeout_begin_opacity=0.8
      animation_duration_move=500
      animation_duration_open=400
      animation_duration_tag=350
      animation_duration_close=800
      animation_duration_focus=0
      animation_curve_open=0.46,1.0,0.29,1
      animation_curve_move=0.46,1.0,0.29,1
      animation_curve_tag=0.46,1.0,0.29,1
      animation_curve_close=0.08,0.92,0,1
      animation_curve_focus=0.46,1.0,0.29,1

      # Scroller Layout Setting
      scroller_structs=20
      scroller_default_proportion=0.8
      scroller_focus_center=0
      scroller_prefer_center=0
      edge_scroller_pointer_focus=1
      scroller_default_proportion_single=1.0
      scroller_proportion_preset=0.5,0.8,1.0

      # Master-Stack Layout Setting
      new_is_master=1
      default_mfact=0.55
      default_nmaster=1
      smartgaps=0

      # Overview Setting
      hotarea_size=10
      enable_hotarea=1
      ov_tab_mode=0
      overviewgappi=5
      overviewgappo=30

      # Misc
      no_border_when_single=0
      axis_bind_apply_timeout=100
      focus_on_activate=1
      inhibit_regardless_of_visibility=0
      sloppyfocus=1
      warpcursor=1
      focus_cross_monitor=0
      focus_cross_tag=0
      enable_floating_snap=0
      snap_distance=30
      cursor_size=24
      drag_tile_to_tile=1

      # keyboard
      repeat_rate=30
      repeat_delay=300
      numlockon=0
      xkb_rules_layout=us

      # Trackpad
      # need relogin to make it apply
      disable_trackpad=0
      tap_to_click=1
      tap_and_drag=1
      drag_lock=1
      trackpad_natural_scrolling=0
      disable_while_typing=1
      left_handed=0
      middle_button_emulation=0
      swipe_min_threshold=1

      # mouse
      # need relogin to make it apply
      mouse_natural_scrolling=0

      # Appearance
      gappih=2
      gappiv=2
      gappoh=4
      gappov=4
      scratchpad_width_ratio=0.8
      scratchpad_height_ratio=0.9
      borderpx=2
      rootcolor=0x${palette.base00}ff           # Background
      bordercolor=0x${palette.base03}ff         # Inactive Border
      focuscolor=0x${palette.base0D}ff          # Active Border (Blue)
      maximizescreencolor=0x${palette.base0B}ff # Green
      urgentcolor=0x${palette.base08}ff         # Red
      scratchpadcolor=0x${palette.base0E}ff     # Purple
      globalcolor=0x${palette.base0C}ff         # Cyan
      overlaycolor=0x${palette.base02}ff        # Selection/Overlay Background

      # layout support:
      # tile,scroller,grid,deck,monocle,center_tile,vertical_tile,vertical_scroller
      tagrule=id:1,layout_name:tile
      tagrule=id:2,layout_name:tile
      tagrule=id:3,layout_name:tile
      tagrule=id:4,layout_name:tile
      tagrule=id:5,layout_name:tile
      tagrule=id:6,layout_name:tile
      tagrule=id:7,layout_name:tile
      tagrule=id:8,layout_name:tile
      tagrule=id:9,layout_name:tile

      # Key Bindings
      # mod keys name: super,ctrl,alt,shift,none

      # reload config
      bind=SUPER,r,reload_config

      # menu and terminal
      bind=SUPER,p,spawn,uwsm app -- ${launcher}
      bind=SUPER,Return,spawn,uwsm app -- ${config.vars.terminal}
      bind=SUPER,o,spawn,uwsm app -- ${clipboard}
      bind=SUPER+SHIFT,o,spawn,uwsm app -- ${emojiPicker}
      bind=SUPER,d,spawn,uwsm app -- ${getExe pkgs.vesktop}

      # exit
      bind=SUPER,x,spawn,uwsm app -- ${powermenu}
      bind=SUPER,w,killclient,

      # Screenshot
      bind=none,Print,spawn,wl-ocr
      bind=CTRL,Print,spawn,${getExe pkgs.grimblast} save area - | ${getExe pkgs.swappy} -f -
      bind=ALT,Print,spawn,${getExe pkgs.grimblast} --notify --cursor copysave output ~/Pictures/Screenshots/$(date +'%F_%H:%M:%S.png')

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
      bind=CTRL,Left,viewtoleft_have_client,0
      bind=SUPER,Right,viewtoright,0
      bind=CTRL,Right,viewtoright_have_client,0
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

      # Window Rules
      windowrule=tags:2,appid:zen-beta
      windowrule=tags:3,appid:vesktop
      windowrule=tags:9,appid:thunderbird
    '';
  };
}
