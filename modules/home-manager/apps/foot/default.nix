{
  pkgs,
  lib,
  ...
}: {
  programs.foot = {
    enable = true;
    settings = {
      main = {
        initial-window-size-chars = "82x23";
        initial-window-mode = "windowed";
        pad = "10x10";
        resize-delay-ms = 100;
        font = "JetBrainsMono Nerd Font:size=10";
        dpi-aware = "auto";
      };
      url = {
        launch = "xdg-open \${url}";
        osc8-underline = "url-mode";
        protocols = "http, https, ftp, ftps, file, gemini, gopher";
        uri-characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-_.,~:;/?#@!$&%*+=\"'";
      };
      mouse = {
        hide-when-typing = "yes";
        alternate-scroll-mode = "yes";
      };
      colors = {
        alpha = 0.77;
        foreground = "cdd6f4"; # Text
        background = "1e1e2e"; # Base
        regular0 = "45475a"; # Surface 1
        regular1 = "f38ba8"; # red
        regular2 = "a6e3a1"; # green
        regular3 = "f9e2af"; # yellow
        regular4 = "89b4fa"; # blue
        regular5 = "f5c2e7"; # pink
        regular6 = "94e2d5"; # teal
        regular7 = "bac2de"; # Subtext 1
        bright0 = "585b70"; # Surface 2
        bright1 = "f38ba8"; # red
        bright2 = "a6e3a1"; # green
        bright3 = "f9e2af"; # yellow
        bright4 = "89b4fa"; # blue
        bright5 = "f5c2e7"; # pink
        bright6 = "94e2d5"; # teal
        bright7 = "a6adc8"; # Subtext 0
      };
    };
  };
}
