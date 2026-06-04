{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkOption
    types
    mkIf
    ;
  cfg = config.mine.ghostty;
  c = config.mine.theme.colors;
in
{
  options.mine.ghostty = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable Ghostty configuration.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.ghostty;
      description = "The Ghostty package to install.";
    };
  };

  config = mkIf cfg.enable {
    hj.packages = [ cfg.package ];

    hj.xdg.config.files."ghostty/config".text = ''
      # General
      auto-update = off

      # Environment
      term = xterm-256color

      # Window
      window-padding-x = 2
      window-padding-y = 2
      window-padding-balance = true
      window-decoration = false
      background-opacity = ${toString config.mine.vars.opacity}
      background-blur-radius = ${if config.mine.vars.opacity < 1.0 then "20" else "0"}
      title = Ghostty

      # Scrolling
      scrollback-limit = 10000

      # Font
      font-size = ${toString config.mine.fonts.size}
      font-family = ${config.mine.fonts.terminal.name}
      font-style = Semibold
      font-style-bold = Bold
      font-style-italic = Italic
      font-style-bold-italic = Bold Italic

      # Colors
      background = ${c.base00}
      foreground = ${c.base05}

      palette = 0=${c.base01}
      palette = 1=${c.base08}
      palette = 2=${c.base0B}
      palette = 3=${c.base0A}
      palette = 4=${c.base0D}
      palette = 5=${c.base0E}
      palette = 6=${c.base0C}
      palette = 7=${c.base05}
      palette = 8=${c.base02}
      palette = 9=${c.base08}
      palette = 10=${c.base0B}
      palette = 11=${c.base0A}
      palette = 12=${c.base0D}
      palette = 13=${c.base0E}
      palette = 14=${c.base0C}
      palette = 15=${c.base07}

      # Cursor
      cursor-style = block
      cursor-style-blink = false
      cursor-invert-fg-bg = true
      cursor-opacity = 1.0

      # Mouse
      mouse-hide-while-typing = false

      # Close pane / tab
      keybind = ctrl+a>x=close_surface
      keybind = ctrl+a>shift+7=close_tab

      # Pane navigation
      keybind = ctrl+a>h=goto_split:left
      keybind = ctrl+a>j=goto_split:bottom
      keybind = ctrl+a>k=goto_split:top
      keybind = ctrl+a>l=goto_split:right

      # Pane resizing
      keybind = ctrl+a>shift+h=resize_split:left,5
      keybind = ctrl+a>shift+j=resize_split:down,5
      keybind = ctrl+a>shift+k=resize_split:up,5
      keybind = ctrl+a>shift+l=resize_split:right,5

      # Splits (v = bottom, ; = right)
      keybind = ctrl+a>v=new_split:down
      keybind = ctrl+a>semicolon=new_split:right

      # Window management
      keybind = ctrl+a>c=new_tab
      keybind = ctrl+a>1=goto_tab:1
      keybind = ctrl+a>2=goto_tab:2
      keybind = ctrl+a>3=goto_tab:3
      keybind = ctrl+a>4=goto_tab:4
      keybind = ctrl+a>5=goto_tab:5
      keybind = ctrl+a>6=goto_tab:6
      keybind = ctrl+a>7=goto_tab:7
      keybind = ctrl+a>8=goto_tab:8
    '';
  };
}
