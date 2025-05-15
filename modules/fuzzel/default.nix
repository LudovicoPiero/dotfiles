{ lib, config, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  inherit (config.myOptions.theme.colorScheme) palette;

  cfg = config.myOptions.fuzzel;
in
{
  options.myOptions.fuzzel = {
    enable = mkEnableOption "fuzzel";
  };

  config = mkIf cfg.enable {
    hj.rum.programs.fuzzel = {
      enable = true;

      settings = {
        main = {
          font = "${config.myOptions.fonts.terminal.name} Semibold:size=${toString config.myOptions.fonts.size}";
          terminal = config.vars.terminal;
          icon-theme = config.myOptions.theme.gtk.theme.name;
          icons-enabled = "yes";
          inner-pad = 15;
          layer = "overlay";
          dpi-aware = "auto";
          exit-on-keyboard-focus-loss = "no";
          fields = "filename,name,generic";
          use-bold = "yes";
          prompt = "->";
          width = 50;
        };

        border = {
          width = 2;
          radius = 0;
        };

        dmenu = {
          mode = "text";
        };

        colors = {
          background = "${palette.base00}f2";
          text = "${palette.base05}ff";
          match = "${palette.base0A}ff";
          selection = "${palette.base03}ff";
          selection-text = "${palette.base05}ff";
          selection-match = "${palette.base0A}ff";
          border = "${palette.base0D}ff";
        };
      };
    };
  };
}
