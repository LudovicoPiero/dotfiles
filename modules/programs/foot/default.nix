{ config, lib, ... }:
let
  inherit (config.mine.theme.colorScheme) palette;
  inherit (lib) mkIf mkEnableOption;

  cfg = config.mine.foot;
in
{
  options.mine.foot.enable = mkEnableOption "foot terminal";

  config = mkIf cfg.enable {
    hm =
      { osConfig, ... }:
      let
        fontConfig = osConfig.mine.fonts;
      in
      {
        programs.foot = {
          enable = true;
          settings = {
            main = {
              font = "${fontConfig.terminal.name}:size=${toString config.mine.fonts.size},${fontConfig.emoji.name}:size=${toString config.mine.fonts.size},${fontConfig.icon.name}:size=${toString config.mine.fonts.size}";
              term = "xterm-256color";
              dpi-aware = "yes";
              initial-window-size-chars = "82x23";
              initial-window-mode = "windowed";
              pad = "10x10";
              resize-delay-ms = 100;
            };

            colors = {
              alpha = osConfig.vars.opacity;
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
  };
}
