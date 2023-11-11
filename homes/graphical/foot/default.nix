{config, ...}: let
  inherit (config.colorScheme) colors;
in {
  programs.foot = {
    enable = true;
    settings = {
      main = {
        term = "xterm-256color";
        font = "Monaspace Neon:size=13,Material Design Icons:size=13,Noto Color Emoji:size=13";
        dpi-aware = "yes";
        initial-window-size-chars = "82x23";
        initial-window-mode = "windowed";
        pad = "10x10";
        resize-delay-ms = 100;
      };

      colors = {
        alpha = "0.8";
        foreground = "${colors.base05}"; # Text
        background = "${colors.base00}"; # colors.base

        regular0 = "${colors.base03}"; # Surface 1
        regular1 = "${colors.base08}"; # red
        regular2 = "${colors.base0B}"; # green
        regular3 = "${colors.base0A}"; # yellow
        regular4 = "${colors.base0D}"; # blue
        regular5 = "${colors.base0F}"; # pink
        regular6 = "${colors.base0C}"; # teal
        regular7 = "${colors.base06}"; # Subtext 0
        # Subtext 1 ???
        bright0 = "${colors.base04}"; # Surface 2
        bright1 = "${colors.base08}"; # red
        bright2 = "${colors.base0B}"; # green
        bright3 = "${colors.base0A}"; # yellow
        bright4 = "${colors.base0D}"; # blue
        bright5 = "${colors.base0F}"; # pink
        bright6 = "${colors.base0C}"; # teal
        bright7 = "${colors.base07}"; # Subtext 0
      };

      mouse = {
        hide-when-typing = "yes";
        alternate-scroll-mode = "yes";
      };
    };
  };
}
