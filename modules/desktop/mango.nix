{
  config,
  lib,
  pkgs,
  inputs,
  inputs',
  ...
}:
let
  inherit (lib)
    mkOption
    types
    mkIf
    getExe
    getExe'
    strip
    ;
  cfg = config.mine.mango;
  c = config.mine.theme.colors;

  screenshot = pkgs.writeShellScriptBin "screenshot" ''
    DIR="$HOME/Pictures/Screenshots"
    FILE="$DIR/$(date +%Y-%m-%d_%H-%M-%S).png"
    mkdir -p "$DIR"
    ${getExe pkgs.grim} -g "$(${getExe pkgs.slurp})" "$FILE"
    ${getExe' pkgs.wl-clipboard "wl-copy"} < "$FILE"
    ${getExe pkgs.libnotify} "Screenshot taken" "Saved to $FILE" -i "$FILE"
  '';

  wl-ocr = pkgs.writeShellScriptBin "wl-ocr" ''
    ${getExe pkgs.grim} -g "$(${getExe pkgs.slurp})" - | ${getExe pkgs.tesseract} - - | ${getExe' pkgs.wl-clipboard "wl-copy"}
    ${getExe pkgs.libnotify} "OCR" "Text copied to clipboard"
  '';

  clipboard-picker = pkgs.writeShellScriptBin "clipboard-picker" ''
    ${getExe pkgs.cliphist} list | ${getExe pkgs.rofi} -dmenu -display-columns 2 | ${getExe pkgs.cliphist} decode | ${getExe' pkgs.wl-clipboard "wl-copy"}
  '';
in
{
  imports = [ inputs.mangowm.nixosModules.mango ];
  options.mine.mango = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable mangowm configuration.";
    };

    package = mkOption {
      type = lib.types.package;
      default = inputs'.mangowm.packages.mango;
      description = "The mangowm package to install.";
    };
  };

  config = mkIf cfg.enable {
    programs.mangowc = {
      enable = true;
      inherit (cfg) package;
    };
    security.pam.services.swaylock.text = "auth include login";

    mine.waybar = {
      enable = true;
      wm = "mangowm";
    };

    environment.systemPackages = with pkgs; [
      swaybg
      mako
      waybar
      brightnessctl
      wireplumber
      libnotify
      polkit_gnome
      wleave
      grim
      slurp
      swappy
      wl-clipboard
      cliphist
      tesseract
      playerctl
      thunar
      thunderbird
    ];

    hj.xdg.config.files."mango/config.conf".text = ''
      # More option see https://github.com/DreamMaoMao/mango/wiki/

      # Autostart
      exec-once=${getExe pkgs.swaybg} -i $HOME/Pictures/Wallpaper/Minato-Aqua-Dark.png
      exec-once=${getExe pkgs.brightnessctl} set 10%
      exec-once=${getExe pkgs.mako}
      exec-once=${getExe pkgs.emacs} --daemon
      exec-once=${getExe' pkgs.wl-clipboard "wl-paste"} --type text --watch ${getExe pkgs.cliphist} store
      exec-once=${getExe' pkgs.wl-clipboard "wl-paste"} --type image --watch ${getExe pkgs.cliphist} store
      exec-once=fcitx5 -d --replace
      exec-once=sleep 1; ${getExe pkgs.waybar}

      # Monitor Settings - HDMI-A-1 (top) at 0,0; eDP-1 (bottom) at 0,1080
      monitorrule=name:^HDMI-A-1$,x:0,y:0,width:1920,height:1080,refresh:180
      monitorrule=name:^eDP-1$,x:0,y:1080,width:1366,height:768,refresh:60

      # Window effect
      blur=0
      blur_layer=0
      blur_optimized=1
      blur_params_num_passes = 2
      blur_params_radius = 2
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
      shadowscolor= 0x000000ff

      border_radius=0
      no_radius_when_single=0
      focused_opacity=1.0
      unfocused_opacity=1.0

      # Animation Configuration(support type:zoom,slide)
      # tag_animation_direction: 1-horizontal,0-vertical
      animations=1
      layer_animations=1
      animation_type_open=slide
      animation_type_close=slide
      animation_fade_in=1
      animation_fade_out=1
      tag_animation_direction=1
      zoom_initial_ratio=0.4
      zoom_end_ratio=0.8
      fadein_begin_opacity=0.5
      fadeout_begin_opacity=0.8
      animation_duration_move=500
      animation_duration_open=400
      animation_duration_tag=194
      animation_duration_close=149
      animation_duration_focus=0
      animation_curve_open=0.05,0.9,0.1,1.05
      animation_curve_move=0.46,1.0,0.29,1
      animation_curve_tag=0.46,1.0,0.29,1
      animation_curve_close=0.08,0.92,0,1
      animation_curve_focus=0.46,1.0,0.29,1
      animation_curve_opafadeout=0.5,0.5,0.5,0.5
      animation_curve_opafadein=0.23,1,0.32,1

      # Scroller Layout Setting
      scroller_structs=20
      scroller_default_proportion=0.8
      scroller_focus_center=0
      scroller_prefer_center=0
      edge_scroller_pointer_focus=1
      edge_scroller_focus_allow_speed=0.0
      scroller_default_proportion_single=1.0
      scroller_proportion_preset=0.5,0.8,1.0

      # Master-Stack Layout Setting
      new_is_master=1
      default_mfact=0.55
      default_nmaster=1
      smartgaps=0

      # Dwindle Layout Setting
      dwindle_smart_split=0
      dwindle_drop_simple_split=1
      dwindle_manual_split=0
      dwindle_hsplit=1
      dwindle_vsplit=1
      dwindle_preserve_split=1

      # Overview Setting
      hotarea_size=10
      enable_hotarea=0
      ov_tab_mode=1
      ov_no_resize=1
      overviewgappi=5
      overviewgappo=30

      # Misc
      no_border_when_single=0
      axis_bind_apply_timeout=100
      focus_on_activate=1
      idleinhibit_ignore_visible=0
      sloppyfocus=1
      warpcursor=1
      focus_cross_monitor=0
      focus_cross_tag=0
      enable_floating_snap=0
      snap_distance=30
      cursor_size=24
      drag_tile_to_tile=1
      drag_tile_small=1

      # keyboard
      repeat_rate=30
      repeat_delay=300
      numlockon=0
      xkb_rules_layout=us
      xkb_rules_options=ctrl:nocaps

      # Trackpad
      disable_trackpad=0
      tap_to_click=1
      tap_and_drag=1
      drag_lock=1
      trackpad_natural_scrolling=1
      disable_while_typing=1
      left_handed=0
      middle_button_emulation=0
      swipe_min_threshold=1

      # mouse
      mouse_natural_scrolling=0

      # Appearance
      gappih=2
      gappiv=2
      gappoh=2
      gappov=2
      scratchpad_width_ratio=0.8
      scratchpad_height_ratio=0.9
      borderpx=2
      rootcolor=0x${strip c.base00}ff
      bordercolor=0x${strip c.base02}ff
      dropcolor=0x${strip c.base0B}55
      splitcolor=0x${strip c.base09}ff
      focuscolor=0x${strip c.base0D}ff
      maximizescreencolor=0x${strip c.base0B}ff
      urgentcolor=0x${strip c.base08}ff
      scratchpadcolor=0x${strip c.base0D}ff
      globalcolor=0x${strip c.base0E}ff
      overlaycolor=0x${strip c.base0C}ff

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

      # Window Rules

      # Workspace 1: Dev & Games
      windowrule=tags:1,noblur:1,isnoanimation:1,appid:^(jetbrains-.*)$
      windowrule=tags:1,appid:^(Albion-Online)$

      # Workspace 2: Secondary browsers
      windowrule=tags:2,appid:^(zen|zen-beta|brave-browser|Chromium-browser|google-chrome|chrome)$
      windowrule=noblur:1,isnoshadow:1,appid:^(zen|zen-beta|brave-browser|Chromium-browser|google-chrome|chrome)$
      windowrule=idleinhibit_when_focus:1,appid:^(zen|zen-beta|brave-browser|Chromium-browser|google-chrome|chrome)$,title:^(.*YouTube.*)$

      # Workspace 3: Firefox
      windowrule=tags:3,appid:^(Firefox|firefox|firefox-esr|floorp)$
      windowrule=noblur:1,isnoshadow:1,appid:^(Firefox|firefox|firefox-esr|floorp)$
      windowrule=idleinhibit_when_focus:1,appid:^(Firefox|firefox|firefox-esr|floorp)$,title:^(.*YouTube.*)$

      # Workspace 4: Social
      windowrule=tags:4,isnoanimation:1,appid:^(org.telegram.desktop)$
      windowrule=isfloating:1,appid:^(org.telegram.desktop)$,title:^(Media viewer)$
      windowrule=tags:4,noblur:1,isnoshadow:1,title:^(.*(Disc|ArmC|WebC)ord.*)$
      windowrule=tags:4,appid:^(vesktop)$

      # Workspace 5: Mail
      windowrule=tags:5,appid:^(thunderbird|org.mozilla.Thunderbird)$

      # Workspace 6: Steam
      windowrule=tags:6,appid:^(steam)$
      windowrule=tags:6,title:^(Sign in to Steam)$
      windowrule=isfloating:1,appid:^(steam)$,title:^(Special Offers)$
      windowrule=isfloating:1,isopensilent:1,appid:^(steam)$,title:^(Steam - News)$
      windowrule=isopensilent:1,appid:^(steam)$,title:^(notificationtoasts_.*_desktop)$
      windowrule=isopensilent:1,appid:^(steam)$,title:^notificationtoasts.*
      windowrule=isopensilent:1,appid:^(steam)$,title:^$

      # Workspace 7: Torrent
      windowrule=tags:7,appid:^(qBittorrent|org.qbittorrent.qBittorrent)$

      # Workspace 8: WhatsApp
      windowrule=tags:8,appid:^(whatsapp-for-linux)$

      # Workspace 9: Music
      windowrule=tags:9,appid:^(spotify|org.fooyin.fooyin|tidal-hifi)$
      windowrule=tags:9,isfloating:0,isnoanimation:1,appid:^(foobar2000.exe)$

      # Floating / Misc
      windowrule=isfloating:1,title:^(Extension: \(Bitwarden Password Manager\))$
      windowrule=isopensilent:1,title:^notificationtoasts.*
      windowrule=isfloating:1,noblur:1,appid:^(xdg-desktop-portal-gtk)$

      # KeePassXC
      windowrule=noblur:1,isnoanimation:1,appid:^(org.keepassxc.KeePassXC)$
      windowrule=isfloating:1,appid:^(org.keepassxc.KeePassXC)$,title:^(Generate Password)$
      windowrule=isfloating:1,appid:^(org.keepassxc.KeePassXC)$,title:^(KeePassXC - Browser Access Request)$

      # Key Bindings
      # key name refer to `xev` or `wev` command output,
      # mod keys name: super,ctrl,alt,shift,none

      # reload config
      bind=SUPER,r,reload_config

      # apps
      bind=SUPER,Return,spawn,${getExe pkgs.${config.mine.vars.terminal}}
      bind=SUPER,E,spawn,${getExe' pkgs.emacs "emacsclient"} -c
      bind=SUPER+SHIFT,E,spawn,${getExe pkgs.thunar}
      bind=SUPER,M,spawn,${getExe pkgs.thunderbird}
      bind=SUPER,P,spawn,${getExe pkgs.rofi} -show drun
      bind=SUPER+SHIFT,P,spawn,${getExe pkgs.rofi} -show window
      bind=SUPER,space,togglefloating,
      bind=SUPER,X,spawn,${getExe pkgs.wleave}

      # clipboard
      bind=SUPER,O,spawn,${getExe clipboard-picker}

      # screenshots & OCR
      bind=NONE,print,spawn,${getExe wl-ocr}
      bind=ALT,print,spawn,${getExe screenshot}

      # exit
      bind=SUPER+SHIFT,c,quit
      bind=SUPER,w,killclient,

      # switch window focus (vim + arrows)
      bind=SUPER,h,focusdir,left
      bind=SUPER,l,focusdir,right
      bind=SUPER,k,focusdir,up
      bind=SUPER,j,focusdir,down
      bind=SUPER,Left,focusdir,left
      bind=SUPER,Right,focusdir,right
      bind=SUPER,Up,focusdir,up
      bind=SUPER,Down,focusdir,down

      # swap window (vim + arrows)
      bind=SUPER+SHIFT,h,exchange_client,left
      bind=SUPER+SHIFT,l,exchange_client,right
      bind=SUPER+SHIFT,k,exchange_client,up
      bind=SUPER+SHIFT,j,exchange_client,down
      bind=SUPER+SHIFT,Left,exchange_client,left
      bind=SUPER+SHIFT,Right,exchange_client,right
      bind=SUPER+SHIFT,Up,exchange_client,up
      bind=SUPER+SHIFT,Down,exchange_client,down

      # switch window status
      bind=SUPER,g,toggleglobal,
      bind=SUPER,Tab,toggleoverview,
      bind=SUPER,backslash,togglefloating,
      bind=SUPER,a,togglemaximizescreen,
      bind=SUPER,f,togglefullscreen,
      bind=SUPER+SHIFT,f,togglefakefullscreen,
      bind=SUPER,i,minimized,
      bind=SUPER+SHIFT,I,restore_minimized
      bind=SUPER,q,toggle_scratchpad
      bind=SUPER+SHIFT,q,tagsilent,special

      # scroller layout
      bind=SUPER,e,set_proportion,1.0
      bind=alt+super+ctrl,Left,scroller_stack,left
      bind=alt+super+ctrl,Right,scroller_stack,right
      bind=alt+super+ctrl,Up,scroller_stack,up
      bind=alt+super+ctrl,Down,scroller_stack,down

      # dwindle layout (manual split mode)
      bind=alt+shift,Return,dwindle_toggle_split_direction

      # switch layout
      bind=SUPER,n,switch_layout

      # tag switch (SUPER+1-9, like hyprland)
      bind=SUPER,1,view,1,0
      bind=SUPER,2,view,2,0
      bind=SUPER,3,view,3,0
      bind=SUPER,4,view,4,0
      bind=SUPER,5,view,5,0
      bind=SUPER,6,view,6,0
      bind=SUPER,7,view,7,0
      bind=SUPER,8,view,8,0
      bind=SUPER,9,view,9,0

      # bind=CTRL,Left,viewtoleft_have_client,0
      # bind=CTRL,Right,viewtoright_have_client,0
      bind=CTRL+SUPER,Left,tagtoleft,0
      bind=CTRL+SUPER,Right,tagtoright,0

      # move client to tag (SUPER+SHIFT+1-9, like hyprland)
      bind=SUPER+SHIFT,1,tag,1,0
      bind=SUPER+SHIFT,2,tag,2,0
      bind=SUPER+SHIFT,3,tag,3,0
      bind=SUPER+SHIFT,4,tag,4,0
      bind=SUPER+SHIFT,5,tag,5,0
      bind=SUPER+SHIFT,6,tag,6,0
      bind=SUPER+SHIFT,7,tag,7,0
      bind=SUPER+SHIFT,8,tag,8,0
      bind=SUPER+SHIFT,9,tag,9,0

      # monitor switch
      bind=alt+shift,Left,focusmon,left
      bind=alt+shift,Right,focusmon,right
      bind=SUPER+Alt,Left,tagmon,left
      bind=SUPER+Alt,Right,tagmon,right

      # gaps
      bind=ALT+SHIFT,X,incgaps,1
      bind=ALT+SHIFT,Z,incgaps,-1
      bind=ALT+SHIFT,R,togglegaps

      # movewin
      bind=CTRL+SHIFT,Up,movewin,+0,-50
      bind=CTRL+SHIFT,Down,movewin,+0,+50
      bind=CTRL+SHIFT,Left,movewin,-50,+0
      bind=CTRL+SHIFT,Right,movewin,+50,+0

      # resizewin
      bind=CTRL+ALT,Up,resizewin,+0,-50
      bind=CTRL+ALT,Down,resizewin,+0,+50
      bind=CTRL+ALT,Left,resizewin,-50,+0
      bind=CTRL+ALT,Right,resizewin,+50,+0

      # media keys
      bind=NONE,XF86AudioRaiseVolume,spawn,${getExe' pkgs.wireplumber "wpctl"} set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%+
      bind=NONE,XF86AudioLowerVolume,spawn,${getExe' pkgs.wireplumber "wpctl"} set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%-
      bind=NONE,XF86AudioMute,spawn,${getExe' pkgs.wireplumber "wpctl"} set-mute @DEFAULT_AUDIO_SINK@ toggle
      bind=NONE,XF86MonBrightnessUp,spawn,${getExe pkgs.brightnessctl} -e4 -n2 set 5%+
      bind=NONE,XF86MonBrightnessDown,spawn,${getExe pkgs.brightnessctl} -e4 -n2 set 5%-
      bind=NONE,XF86AudioPlay,spawn,${getExe pkgs.playerctl} play-pause
      bind=NONE,XF86AudioNext,spawn,${getExe pkgs.playerctl} next
      bind=NONE,XF86AudioPrev,spawn,${getExe pkgs.playerctl} previous

      # Mouse Button Bindings
      mousebind=SUPER,btn_left,moveresize,curmove
      mousebind=NONE,btn_middle,togglemaximizescreen,0
      mousebind=SUPER,btn_right,moveresize,curresize

      # Axis Bindings
      axisbind=SUPER,UP,viewtoleft_have_client
      axisbind=SUPER,DOWN,viewtoright_have_client

      # layer rule
      layerrule=animation_type_open:zoom,layer_name:rofi
      layerrule=animation_type_close:zoom,layer_name:rofi
    '';
  };
}
