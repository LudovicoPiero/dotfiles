{ config, lib, ... }:
let
  cfg = config.mine.mangowc;
  cfgmine = config.mine;
  inherit (config.mine.theme.colorScheme) palette;
  inherit (lib) mkIf;
in
mkIf cfgmine.mangowc.enable {
  hj = {
    packages = [ cfg.package ];
    xdg.config.files."mango/config.conf".text = ''
      # More option see https://github.com/DreamMaoMao/mango/wiki/
      # Environment Variables
      env=XCURSOR_THEME,${cfgmine.theme.cursor.name}
      env=XCURSOR_SIZE,${toString cfgmine.theme.cursor.size}
      env=GTK_IM_MODULE,fcitx
      env=QT_IM_MODULE,fcitx
      env=SDL_IM_MODULE,fcitx
      env=XMODIFIERS,@im=fcitx
      env=GLFW_IM_MODULE,ibus

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
      xkb_rules_options=ctrl:nocaps

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
    '';
  };
}
