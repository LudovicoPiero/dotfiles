{
  border = 2;
  titlebar = false;
  commands = [
    # hack around spotify's wm_class bug: https://github.com/swaywm/sway/issues/3793
    {
      criteria = {class = "Spotify";};
      command = "move to workspace 5";
    }
    {
      criteria = {class = "WebCord";};
      command = "move to workspace 3";
    }
    {
      criteria = {app_id = "chromium-browser";};
      command = "move to workspace 2";
    }
    {
      criteria = {app_id = "firefox";};
      command = "move to workspace 2";
    }
    {
      criteria = {class = "Chromium-browser";};
      command = "move to workspace 2";
    }
    {
      criteria = {class = "discord";};
      command = "move to workspace 3";
    }
    {
      criteria = {app_id = "discord";};
      command = "move to workspace 3";
    }
    {
      criteria = {app_id = "org.telegram.desktop";};
      command = "move to workspace 4";
    }
    {
      criteria = {class = "Mailspring";};
      command = "move to workspace 9";
    }
  ];
}
