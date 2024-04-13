{ config, ... }:
let
  inherit (config.colorScheme) palette;
in
{
  programs.foot = {
    enable = true;
    settings = {
      main = {
        term = "screen-256color";
        font = "Iosevka q:size=15,Material Design Icons:size=15,Noto Color Emoji:size=15,Symbols Nerd Font:size=15";
        dpi-aware = "yes";
        initial-window-size-chars = "82x23";
        initial-window-mode = "windowed";
        pad = "10x10";
        resize-delay-ms = 100;
      };

      colors = {
        alpha = "0.88";
        foreground = "${palette.base05}"; # Text
        background = "${palette.base00}"; # colors.base

        regular0 = "${palette.base03}"; # Surface 1
        regular1 = "${palette.base08}"; # red
        regular2 = "${palette.base0B}"; # green
        regular3 = "${palette.base0A}"; # yellow
        regular4 = "${palette.base0D}"; # blue
        regular5 = "${palette.base0F}"; # pink
        regular6 = "${palette.base0C}"; # teal
        regular7 = "${palette.base06}"; # Subtext 0
        # Subtext 1 ???
        bright0 = "${palette.base04}"; # Surface 2
        bright1 = "${palette.base08}"; # red
        bright2 = "${palette.base0B}"; # green
        bright3 = "${palette.base0A}"; # yellow
        bright4 = "${palette.base0D}"; # blue
        bright5 = "${palette.base0F}"; # pink
        bright6 = "${palette.base0C}"; # teal
        bright7 = "${palette.base07}"; # Subtext 0
      };

      mouse = {
        hide-when-typing = "yes";
        alternate-scroll-mode = "yes";
      };
    };
  };
}
