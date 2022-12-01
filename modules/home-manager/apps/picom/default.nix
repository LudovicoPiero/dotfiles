{pkgs, ...}: {
  home.packages = with pkgs; [picom-jonaburg];
  xdg.configFile = {
    "picom.conf".text = ''
      transition-length = 300
      transition-pow-x = 0.1
      transition-pow-y = 0.1
      transition-pow-w = 0.1
      transition-pow-h = 0.1
      size-transition = true
      corner-radius = 10.0;
      rounded-corners-exclude = [
        #"window_type = 'normal'",
        "class_g = 'awesome'",
        "class_g = 'URxvt'",
        "class_g = 'XTerm'",
        "class_g = 'kitty'",
        "class_g = 'Alacritty'",
        "class_g = 'Polybar'",
        "class_g = 'code-oss'",
        #"class_g = 'TelegramDesktop'",
        "class_g = 'firefox'",
        "class_g = 'Thunderbird'"
      ];
      round-borders = 1;
      round-borders-exclude = [
        #"class_g = 'TelegramDesktop'",
      ];
      shadow = false
      shadow-radius = 7;
      shadow-offset-x = -7;
      shadow-offset-y = -7;
      shadow-exclude = [
        "name = 'Notification'",
        "class_g = 'Conky'",
        "class_g ?= 'Notify-osd'",
        "class_g = 'Cairo-clock'",
        "class_g = 'slop'",
        "class_g = 'Polybar'",
        "_GTK_FRAME_EXTENTS@:c"
      ];
      fading = true;
      fade-in-step = 0.03;
      fade-out-step = 0.03;
      fade-exclude = [
        "class_g = 'slop'"   # maim
      ]
      inactive-opacity = 0.8;
      frame-opacity = 0.7;
      popup_menu = { opacity = 0.8; }
      dropdown_menu = { opacity = 0.8; }
      inactive-opacity-override = false;
      active-opacity = 1.0;
      focus-exclude = [
        "class_g = 'Cairo-clock'",
        "class_g = 'Bar'",                    # lemonbar
        "class_g = 'slop'"                    # maim
      ];
      opacity-rule = [
        "80:class_g     = 'Bar'",             # lemonbar
        "100:class_g    = 'slop'",            # maim
        "100:class_g    = 'XTerm'",
        "100:class_g    = 'URxvt'",
        "100:class_g    = 'kitty'",
        "100:class_g    = 'Alacritty'",
        "80:class_g     = 'Polybar'",
        "100:class_g    = 'code-oss'",
        "100:class_g    = 'Meld'",
        "70:class_g     = 'TelegramDesktop'",
        "90:class_g     = 'Joplin'",
        "100:class_g    = 'firefox'",
        "100:class_g    = 'Thunderbird'"
      ];
      blur: {
        # requires: https://github.com/ibhagwan/picom
        method = "kawase";
        #method = "kernel";
        strength = 7;
        # deviation = 1.0;
        # kernel = "11x11gaussian";
        background = false;
        background-frame = false;
        background-fixed = false;
        kern = "3x3box";
      }
      blur-background-exclude = [
        #"window_type = 'dock'",
        #"window_type = 'desktop'",
        #"class_g = 'URxvt'",
        #
        # prevents picom from blurring the background
        # when taking selection screenshot with `main`
        # https://github.com/naelstrof/maim/issues/130
        "class_g = 'slop'",
        "_GTK_FRAME_EXTENTS@:c"
      ];
      experimental-backends = true;
      backend = "glx";
      vsync = true
      mark-wmwin-focused = true;
      mark-ovredir-focused = true;
      detect-rounded-corners = true;
      detect-client-opacity = true;
      refresh-rate = 0
      detect-transient = true
      detect-client-leader = true
      use-damage = false
      log-level = "info";
      wintypes:
      {
        normal = { fade = false; shadow = false; }
        tooltip = { fade = true; shadow = true; opacity = 0.75; focus = true; full-shadow = false; };
        dock = { shadow = false; }
        dnd = { shadow = false; }
        popup_menu = { opacity = 0.8; }
        dropdown_menu = { opacity = 0.8; }
      };
    '';
  };
}
