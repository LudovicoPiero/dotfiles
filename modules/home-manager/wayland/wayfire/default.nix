{pkgs, ...}: {
  home.packages = with pkgs; [
    wayfire
    swaybg
  ];

  imports = [
    ../../apps/mako
    ../../apps/waybar
    ../../apps/foot
    ../../apps/kitty
    ../../apps/wofi
    ../../apps/tmux
  ];

  xdg.configFile."wayfire.ini".text = ''
    [input]
    ## Keyboard
    #xkb_layout = us,fr
    #xkb_variant = dvorak,bepo
    #kb_repeat_delay = 400
    #kb_repeat_rate = 40
    #modifier_binding_timeout = 400
    kb_numlock_default_state = false
    kb_capslock_default_state = false

    ## Mouse / Touchpad (libinput)
    mouse_accel_profile = default
    touchpad_accel_profile = default
    tap_to_click = true
    click_method = default
    scroll_method = default
    disable_touchpad_while_typing = true
    disable_touchpad_while_mouse  = false
    natural_scroll = true
    mouse_cursor_speed = 0.5
    touchpad_cursor_speed = 0.5
    mouse_scroll_speed = 1.0
    touchpad_scroll_speed = 1.0
    cursor_theme = capitaine-cursors-white
    cursor_size = 24

    # See Input options for a complete reference.
    # https://github.com/WayfireWM/wayfire/wiki/Configuration#input

    # Output configuration ─────────────────────────────────────────────────────────

    # Example configuration:
    #
    [output:eDP-1]
    mode = 1920x1080@60000
    position = 0,0
    transform = normal
    scale = 1.000000
    #
    # See Output options for a complete reference.
    # https://github.com/WayfireWM/wayfire/wiki/Configuration#output

    # Core options ─────────────────────────────────────────────────────────────────

    [core]
    # List of plugins to be enabled.
    # See the Configuration document for a complete list.
    plugins = \
      alpha \
      animate \
      autostart \
      command \
      cube \
      decoration \
      expo \
      fast-switcher \
      fisheye \
      grid \
      idle \
      invert \
      move \
      oswitch \
      place \
      resize \
      switcher \
      scale \
      vswitch \
      vswipe \
      window-rules \
      wm-actions \
      wrot \
      zoom

    # Note: [blur] is not enabled by default, because it can be resource-intensive.
    # Feel free to add it to the list if you want it.
    # You can find its documentation here:
    # https://github.com/WayfireWM/wayfire/wiki/Configuration#blur

    # Root background color.
    background_color = 0.1 0.1 0.1 1.0

    # Close focused window.
    close_top_view = <super> KEY_W | <super> KEY_Q | <alt> KEY_F4

    # Workspaces arranged into a grid: 3 × 3.
    vwidth = 3
    vheight = 3

    # Prefer client-side decoration or server-side decoration
    preferred_decoration_mode = server

    # Enables or disables XWayland support, which allows X11 applications to be used
    xwayland = true

    # Mouse bindings ───────────────────────────────────────────────────────────────

    # Drag windows by holding down Super and left mouse button.
    [move]
    activate = <super> BTN_LEFT

    # Resize them with right mouse button + Super.
    [resize]
    activate = <super> BTN_RIGHT

    # Zoom in the desktop by scrolling + Super.
    [zoom]
    modifier = <super>
    smoothing_duration = 300
    speed = 0.01

    # Change opacity by scrolling with Super + Alt.
    [alpha]
    modifier = <super> <alt>
    min_value = 0.1

    # Rotate windows with the mouse.
    [wrot]
    activate = <super> <ctrl> BTN_RIGHT

    # Fisheye effect.
    [fisheye]
    toggle = <super> <ctrl> KEY_F
    radius = 450.0
    zoom = 7.0

    # Startup commands ─────────────────────────────────────────────────────────────

    [autostart]
    0_environment = dbus-update-activation-environment --systemd WAYLAND_DISPLAY DISPLAY XAUTHORITY
    1_hm = systemctl --user start graphical-session.target

    # Set wallpaper
    set_wallpaper = swaybg --output '*' --mode fill --image ~/.config/wayfire/Wallpaper/wall.png &

    # Lauch notification daemon (mako)
    start_notify = mako &

    # Lauch statusbar (waybar)
    start_statusbar = waybar &

    # Automatically start background and panel.
    # Set to false if you want to override the default clients.
    autostart_wf_shell = false

    # Idle ─────────────────────────────────────────────────────────────────────────
    [idle]
    toggle = <super> KEY_Z
    screensaver_timeout = 300
    dpms_timeout = 600
    disable_on_fullscreen = true
    cube_max_zoom = 1.5
    cube_rotate_speed = 1.5
    cube_zoom_speed = 1000

    # Disables the compositor going idle with Super + z.
    # This will lock your screen after 300 seconds of inactivity, then turn off
    # your displays after another 300 seconds.

    # Applications ─────────────────────────────────────────────────────────────────

    [command]

    # -- Terminal --
    binding_terminal = <super> KEY_ENTER
    command_terminal = kitty

    binding_terminal_area = <super> <shift> KEY_ENTER
    command_terminal_area = foot

    # -- Apps --
    binding_files = <super> KEY_E
    command_files = thunar

    binding_web = <super> KEY_G
    command_web = firefox

    # -- Wofi --
    binding_launcher = <super> KEY_P
    command_launcher = ~/.config/wayfire/scripts/bemenu

    binding_powermenu = <super> KEY_X
    command_powermenu = ~/.config/wayfire/scripts/powermenu

    # -- Screenshots --
    # If this does not work on your computer, Replace KEY_SYSRQ with KEY_PRINT
    binding_screenshot_5 = KEY_SYSRQ
    command_screenshot_5 = grimblast --notify --cursor copysave output

    binding_screenshot = <ctrl> KEY_SYSRQ
    command_screenshot = grimblast --notify copysave area

    # -- Volume controls --
    repeatable_binding_volume_up = KEY_VOLUMEUP
    command_volume_up = pamixer -i 5

    repeatable_binding_volume_down = KEY_VOLUMEDOWN
    command_volume_down = pamixer -d 5

    # -- Screen brightness --
    repeatable_binding_light_up = KEY_BRIGHTNESSUP
    command_light_up = brightnessctl set +5%

    repeatable_binding_light_down = KEY_BRIGHTNESSDOWN
    command_light_down = brightnessctl set 5%-

    # Windows ──────────────────────────────────────────────────────────────────────

    # Actions related to window management functionalities.
    [wm-actions]
    toggle_fullscreen = <super> KEY_SPACE
    toggle_always_on_top = <super> <shift> KEY_T
    toggle_sticky = <super> <shift> KEY_S

    # Position the windows in certain regions of the output.
    [grid]
    #
    # ⇱ ↑ ⇲   │ 7 8 9
    # ← f →   │ 4 5 6
    # ⇱ ↓ ⇲ d │ 1 2 3 0
    # ‾   ‾
    slot_l = <super> KEY_LEFT | <super> KEY_KP4
    slot_c = <super> KEY_UP | <super> KEY_KP5
    slot_r = <super> KEY_RIGHT | <super> KEY_KP6
    slot_bl = <super> KEY_J | <super> KEY_KP1
    slot_br = <super> KEY_L | <super> KEY_KP3
    slot_tl = <super> KEY_H | <super> KEY_KP7
    slot_tr = <super> KEY_K | <super> KEY_KP9
    slot_b = <super> KEY_COMMA | <super> KEY_KP2
    slot_t = <super> KEY_DOT | <super> KEY_KP8
    # Restore default
    restore = <super> KEY_DOWN | <super> KEY_KP0
    duration = 300
    # type = wobbly
    type = simple

    # Change active window with an animation.
    [switcher]
    next_view = <alt> KEY_TAB
    prev_view = <alt> <shift> KEY_TAB
    speed = 300
    touch_sensitivity = 1.0
    view_thumbnail_scale = 1.0

    # Simple active window switcher.
    [fast-switcher]
    activate = <super> KEY_TAB

    # Workspaces ───────────────────────────────────────────────────────────────────

    # Switch to workspace.
    [vswitch]
    binding_left = <ctrl> <super> KEY_LEFT
    binding_down = <ctrl> <super> KEY_DOWN
    binding_up = <ctrl> <super> KEY_UP
    binding_right = <ctrl> <super> KEY_RIGHT
    # Move the focused window with the same key-bindings, but add Shift.
    with_win_left = <ctrl> <super> <shift> KEY_LEFT
    with_win_down = <ctrl> <super> <shift> KEY_DOWN
    with_win_up = <ctrl> <super> <shift> KEY_UP
    with_win_right = <ctrl> <super> <shift> KEY_RIGHT
    duration = 300
    gap = 20
    background = 0.1 0.1 0.1 1.0
    wraparound = false

    # Show the current workspace row as a cube.
    [cube]
    activate = <ctrl> <alt> BTN_LEFT
    background = 0.1 0.1 0.1 1.0
    background_mode = simple
    deform = 0
    initial_animation = 350
    light = true
    speed_spin_horiz = 0.02
    speed_spin_vert = 0.02
    speed_zoom = 0.07
    zoom = 0.1
    # Switch to the next or previous workspace.
    rotate_left = <ctrl> <alt> KEY_LEFT
    rotate_right = <ctrl> <alt> KEY_RIGHT

    # Show an overview of all workspaces.
    [expo]
    toggle = <super>
    background = 0.7 0.4 0.5 1.0
    duration = 300
    offset = 10.0

    # Select a workspace.
    # Workspaces are arranged into a grid of 3 × 3.
    # The numbering is left to right, line by line.
    #
    # ⇱ k ⇲
    # h ⏎ l
    # ⇱ j ⇲
    # ‾   ‾
    # See core.vwidth and core.vheight for configuring the grid.
    select_workspace_1 = KEY_1
    select_workspace_2 = KEY_2
    select_workspace_3 = KEY_3
    select_workspace_4 = KEY_4
    select_workspace_5 = KEY_5
    select_workspace_6 = KEY_6
    select_workspace_7 = KEY_7
    select_workspace_8 = KEY_8
    select_workspace_9 = KEY_9

    # Outputs ──────────────────────────────────────────────────────────────────────

    # Change focused output.
    [oswitch]
    # Switch to the next output.
    next_output = <super> KEY_O
    # Same with the window.
    next_output_with_win = <super> <shift> KEY_O

    # Invert the colors of the whole output.
    [invert]
    toggle = <super> KEY_I

    # Misc ────────────────────────────────────────────────────────────────────────

    # A plugin which shows all the windows on the current or on all workspaces, similar to GNOME's Overview.
    [scale]
    toggle = <super> KEY_V
    toggle_all = <super> <shift> KEY_V
    spacing = 50
    duration = 300
    interact = true
    inactive_alpha = 0.90
    allow_zoom = true
    middle_click_close = true

    # A plugin to swipe workspaces in a grid.
    [vswipe]
    background = 0.1 0.1 0.1 1.0
    delta_threshold = 24.0
    duration = 180
    enable_horizontal = true
    enable_smooth_transition = true
    enable_vertical = false
    fingers = 3
    gap = 32.0
    speed_cap = 0.05
    speed_factor = 256.0
    threshold = 0.35

    # A plugin which provides animations when a window is opened or closed.
    [animate]
    open_animation = zoom
    close_animation = zoom
    duration = 300
    startup_duration = 600
    zoom_duration = 300
    zoom_enabled_for = none
    enabled_for = (type is "toplevel" | (type is "x-or" & focusable is true) | app_id is "wofi" | app_id is "waybar")
    fade_duration = 300
    fade_enabled_for = type is "overlay"

    # A plugin to blur windows.
    [blur]
    method = kawase
    kawase_degrade = 1
    kawase_iterations = 2
    kawase_offset = 5
    mode = normal

    # Default decorations around XWayland windows.
    [decoration]
    active_color = 0.9 0.4 0.5 1.0
    inactive_color = 0.3 0.3 0.3 1.0
    border_size = 2
    button_order = minimize maximize close
    font = JetBrainsMono Nerd Font 10
    title_height = 0
    ignore_views = none

    # A plugin to get wobbly windows.
    # [wobbly]
    # friction = 3.0
    # spring_k = 8.0
    # grid_resolution = 6

    # A plugin to move windows around by dragging them from any part (not just the title bar).
    [move]
    enable_snap = true
    enable_snap_off = true
    snap_threshold = 10
    snap_off_threshold = 10
    join_views = false

    # A plugin to position newly opened windows.
    [place]
    mode = center

    # Rules ────────────────────────────────────────────────────────────────────────

    # Example configuration:
    #
    [window-rules]
    firefox_rules = on created if app_id is "firefox" then assign_workspace 1 2
    discord_rules = on created if app_id is "Discord" then assign_workspace 1 3
    #
    # You can get the properties of your applications with the following command:
    # $ WAYLAND_DEBUG=1 alacritty 2>&1 | kak
    #
    # See Window rules for a complete reference.
    # https://github.com/WayfireWM/wayfire/wiki/Configuration#window-rules
  '';

  xdg.configFile = {
    "wayfire" = {
      source = ./.;
    };
  };
}
