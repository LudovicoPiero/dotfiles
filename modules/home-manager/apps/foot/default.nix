{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (config.colorScheme) colors;
in {
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
        background = "${colors.base00}";
        foreground = "${colors.base05}";
        regular0 = "${colors.base01}";
        regular1 = "${colors.base08}";
        regular2 = "${colors.base0B}";
        regular3 = "${colors.base0A}";
        regular4 = "${colors.base0D}";
        regular5 = "${colors.base0E}";
        regular6 = "${colors.base0C}";
        regular7 = "${colors.base06}";
        bright0 = "${colors.base02}";
        bright1 = "${colors.base08}";
        bright2 = "${colors.base0B}";
        bright3 = "${colors.base0A}";
        bright4 = "${colors.base0D}";
        bright5 = "${colors.base0E}";
        bright6 = "${colors.base0C}";
        bright7 = "${colors.base07}";
      };
    };
  };
}
