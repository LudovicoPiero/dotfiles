{config, ...}: let
  inherit (config) colorScheme;
  inherit (colorScheme) palette;
in {
  programs.alacritty = {
    enable = true;

    settings = {
      font = {
        normal.family = "Iosevka q SemiBold";
        bold.family = "Iosevka q";
        italic.family = "Iosevka q";
        size = 15;
      };

      window = {
        decorations = "None";
        dynamic_padding = true;
        padding = {
          x = 5;
          y = 5;
        };
        opacity = 0.88;
        startup_mode = "Maximized";
      };

      scrolling = {
        history = 1000;
        multiplier = 5;
      };

      mouse.hide_when_typing = true;

      colors = {
        primary.background = "#${palette.base00}";
        primary.foreground = "#${palette.base07}";
        cursor.text = "#${palette.base00}";
        cursor.cursor = "#${palette.base07}";
        normal.black = "#${palette.base00}";
        normal.red = "#${palette.base08}";
        normal.green = "#${palette.base0B}";
        normal.yellow = "#${palette.base0A}";
        normal.blue = "#${palette.base0D}";
        normal.magenta = "#${palette.base0E}";
        normal.cyan = "#${palette.base0B}";
        normal.white = "#${palette.base05}";
        bright.black = "#${palette.base03}";
        bright.red = "#${palette.base09}";
        bright.green = "#${palette.base01}";
        bright.yellow = "#${palette.base02}";
        bright.blue = "#${palette.base04}";
        bright.magenta = "#${palette.base06}";
        bright.cyan = "#${palette.base0F}";
        bright.white = "#${palette.base07}";
      };
    };
  };
}
