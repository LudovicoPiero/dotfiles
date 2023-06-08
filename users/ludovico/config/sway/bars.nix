{colorscheme}:
with colorscheme.colors; [
  {
    statusCommand = "i3status-rs ~/.config/i3status-rust/config-bottom.toml";
    fonts = {
      names = ["Iosevka Nerd Font" "Font Awesome 6 Free" "Font Awesome 6 Brands"];
      size = 9.0;
    };
    position = "bottom";
    colors = {
      background = "#${base00}";
      separator = "#${base01}";
      statusline = "#${base04}";
      focusedWorkspace = {
        border = "#${base05}";
        background = "#${base0D}";
        text = "#${base00}";
      };
      activeWorkspace = {
        border = "#${base05}";
        background = "#${base03}";
        text = "#${base00}";
      };
      inactiveWorkspace = {
        border = "#${base03}";
        background = "#${base01}";
        text = "#${base05}";
      };
      urgentWorkspace = {
        border = "#${base08}";
        background = "#${base08}";
        text = "#${base00}";
      };
      bindingMode = {
        border = "#${base00}";
        background = "#${base0A}";
        text = "#${base00}";
      };
    };
  }
]
