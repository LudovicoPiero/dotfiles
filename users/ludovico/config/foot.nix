{colorscheme}:
with colorscheme.colors; {
  main = {
    term = "xterm-256color";
    font = "Iosevka Nerd Font:size=13";
    dpi-aware = "auto";
    initial-window-size-chars = "82x23";
    initial-window-mode = "windowed";
    pad = "10x10";
    resize-delay-ms = 100;
  };

  colors = {
    alpha = "0.88";
    foreground = "${base05}"; # Text
    background = "${base00}"; # Base

    regular0 = "${base03}"; # Surface 1
    regular1 = "${base08}"; # red
    regular2 = "${base0B}"; # green
    regular3 = "${base0A}"; # yellow
    regular4 = "${base0D}"; # blue
    regular5 = "${base0F}"; # pink
    regular6 = "${base0C}"; # teal
    regular7 = "${base06}"; # Subtext 0
    # Subtext 1 ???
    bright0 = "${base04}"; # Surface 2
    bright1 = "${base08}"; # red
    bright2 = "${base0B}"; # green
    bright3 = "${base0A}"; # yellow
    bright4 = "${base0D}"; # blue
    bright5 = "${base0F}"; # pink
    bright6 = "${base0C}"; # teal
    bright7 = "${base07}"; # Subtext 0
  };

  mouse = {
    hide-when-typing = "yes";
    alternate-scroll-mode = "yes";
  };
}
