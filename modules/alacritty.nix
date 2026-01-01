{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkOption types mkIf;
  cfg = config.mine.alacritty;
in
{
  options.mine.alacritty = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable Alacritty configuration.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.alacritty;
      description = "The Alacritty package to install.";
    };
  };

  config = mkIf cfg.enable {
    hj.packages = [ cfg.package ];

    hj.xdg.config.files."alacritty/alacritty.toml".text = ''
      [general]
      live_config_reload = true

      [window]
      dimensions = { columns = 0, lines = 0 }
      padding = { x = 2, y = 2 }
      dynamic_padding = true
      decorations = "None"
      opacity = ${toString config.mine.vars.opacity}
      blur = true
      startup_mode = "Windowed"
      title = "Alacritty"
      dynamic_title = true

      [scrolling]
      history = 10000
      multiplier = 3

      [font]
      size = ${toString config.mine.fonts.size}

      [font.normal]
      family = "${config.mine.fonts.terminal.name}"
      style = "Semibold"

      [font.bold]
      family = "${config.mine.fonts.terminal.name}"
      style = "Bold"

      [font.italic]
      style = "Italic"

      [font.bold_italic]
      style = "Bold Italic"

      [colors.primary]
      background = "#1a1b26"
      foreground = "#c0caf5"

      [colors.normal]
      black =   "#15161e"
      red =     "#f7768e"
      green =   "#9ece6a"
      yellow =  "#e0af68"
      blue =    "#7aa2f7"
      magenta = "#bb9af7"
      cyan =    "#7dcfff"
      white =   "#a9b1d6"

      [colors.bright]
      black =   "#414868"
      red =     "#f7768e"
      green =   "#9ece6a"
      yellow =  "#e0af68"
      blue =    "#7aa2f7"
      magenta = "#bb9af7"
      cyan =    "#7dcfff"
      white =   "#c0caf5"

      [cursor]
      style = { shape = "Block", blinking = "Off" }
      unfocused_hollow = true
      thickness = 0.15

      [mouse]
      hide_when_typing = false

      [[keyboard.bindings]]
      key = "Up"
      mods = "Shift"
      action = "ScrollLineUp"

      [[keyboard.bindings]]
      key = "Down"
      mods = "Shift"
      action = "ScrollLineDown"

      [[keyboard.bindings]]
      key = "["
      mods = "Control"
      action = "ToggleViMode"
    '';
  };
}
