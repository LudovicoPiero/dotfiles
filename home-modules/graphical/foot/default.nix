{
  config,
  lib,
  ...
}: let
  cfg = config.mine.foot;
  inherit (config) colorScheme;
  inherit (colorScheme) palette;
  inherit (lib) mkOption mkIf types;
in {
  options.mine.foot = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Enable foot and set configuration.
      '';
    };
  };

  config = mkIf cfg.enable {
    programs.foot = {
      enable = true;
      settings = {
        main = {
          term = "xterm-256color";
          font = "Iosevka q:size=13,Material Design Icons:size=13,Noto Color Emoji:size=13";
          dpi-aware = "yes";
          initial-window-size-chars = "82x23";
          initial-window-mode = "windowed";
          pad = "10x10";
          resize-delay-ms = 100;
        };

        colors = {
          alpha = "0.8";
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
  };
}
