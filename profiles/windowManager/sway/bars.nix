{
  pkgs,
  colors,
  lib,
  inputs,
}: [
  {
    #statusCommand = "i3status-rs ~/.config/i3status-rust/config-bottom.toml";
    # statusCommand = "${pkgs.i3status}/bin/i3status";
    command = "waybar";
    fonts = {
      names = ["Google Sans" "Font Awesome 6 Free" "Font Awesome 6 Brands"];
      size = 9.0;
    };
    position = "bottom";
    colors = {
      background = "#${colors.base00}";
      separator = "#${colors.base01}";
      statusline = "#${colors.base04}";
      focusedWorkspace = {
        border = "#${colors.base05}";
        background = "#${colors.base0D}";
        text = "#${colors.base00}";
      };
      activeWorkspace = {
        border = "#${colors.base05}";
        background = "#${colors.base03}";
        text = "#${colors.base00}";
      };
      inactiveWorkspace = {
        border = "#${colors.base03}";
        background = "#${colors.base01}";
        text = "#${colors.base05}";
      };
      urgentWorkspace = {
        border = "#${colors.base08}";
        background = "#${colors.base08}";
        text = "#${colors.base00}";
      };
      bindingMode = {
        border = "#${colors.base00}";
        background = "#${colors.base0A}";
        text = "#${colors.base00}";
      };
    };
  }
]
