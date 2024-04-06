{
  palette,
  pkgs,
  lib,
  ...
}: [
  {
    statusCommand = "${lib.getExe pkgs.i3status}";
    # statusCommand = "${lib.getExe pkgs.i3status-rust} ~/.config/i3status-rust/config-bottom.toml";
    fonts = {
      names = [
        "Iosevka q"
        "Symbols Nerd Font"
      ];
      size = 8.0;
    };
    position = "bottom";
    colors = {
      background = "#${palette.base00}";
      separator = "#${palette.base05}";
      statusline = "#${palette.base05}";
      focusedWorkspace = {
        border = "#${palette.base05}";
        background = "#${palette.base0D}";
        text = "#${palette.base00}";
      };
      activeWorkspace = {
        border = "#${palette.base05}";
        background = "#${palette.base03}";
        text = "#${palette.base00}";
      };
      inactiveWorkspace = {
        border = "#${palette.base03}";
        background = "#${palette.base01}";
        text = "#${palette.base05}";
      };
      urgentWorkspace = {
        border = "#${palette.base08}";
        background = "#${palette.base08}";
        text = "#${palette.base00}";
      };
      bindingMode = {
        border = "#${palette.base00}";
        background = "#${palette.base0A}";
        text = "#${palette.base00}";
      };
    };
  }
]
