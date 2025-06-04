{
  hm.wayland.windowManager.sway.config.window = {
    border = 2;
    titlebar = false;
    commands = [
      {
        criteria = {
          title = "(?i)(open|save)( as)? (file|folder|directory)?";
        };
        command = "floating enable, resize set width 800 height 600";
      }

      # Handle popup/dialog globally
      {
        criteria = {
          window_role = "popup";
        };
        command = "floating enable";
      }
      {
        criteria = {
          app_id = "xdg-desktop-portal";
        };
        command = "floating enable, resize set width 800 height 600";
      }
      {
        criteria = {
          app_id = "thunderbird";
        };
        command = "move to workspace 9";
      }
      {
        criteria = {
          app_id = "org.telegram.desktop";
        };
        command = "move to workspace 4";
      }
      {
        criteria = {
          app_id = "^(discord|vesktop|WebCord)$";
        };
        command = "move to workspace 3";
      }
      {
        criteria = {
          app_id = "^(chromium-browser|firefox|floorp|zen-browser)$";
        };
        command = "move to workspace 2";
      }
    ];
  };
}
