{
  hm.wayland.windowManager.sway.config.window = {
    border = 2;
    titlebar = false;
    commands = [
      {
        criteria = {
          title = "(?:Open|Save) (?:File|Folder|As)";
        };
        command = "floating enable, resize set width 800 height 600";
      }

      {
        criteria = {
          app_id = "thunderbird";
        };
        command = "move to workspace 9";
      }
      # hack around spotify's wm_class bug: https://github.com/swaywm/sway/issues/3793
      {
        criteria = {
          class = "Spotify";
        };
        command = "move to workspace 5";
      }
      {
        criteria = {
          app_id = "org.telegram.desktop";
        };
        command = "move to workspace 4";
      }
      {
        criteria = {
          app_id = "WebCord";
        };
        command = "move to workspace 3";
      }
      {
        criteria = {
          app_id = "chromium-browser";
        };
        command = "move to workspace 2";
      }
      {
        criteria = {
          app_id = "discord";
        };
        command = "move to workspace 3";
      }
      {
        criteria = {
          app_id = "vesktop";
        };
        command = "move to workspace 3";
      }
      {
        criteria = {
          app_id = "firefox";
        };
        command = "move to workspace 2";
      }
      {
        criteria = {
          app_id = "floorp";
        };
        command = "move to workspace 2";
      }
    ];
  };
}
