{
  lib,
  config,
  inputs,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf getExe;
  inherit (config.mine.theme.colorScheme) palette;

  app2unit = "${getExe inputs.ludovico-pkgs.packages.${pkgs.stdenv.hostPlatform.system}.app2unit}";

  cfg = config.mine.fuzzel;
in
{
  options.mine.fuzzel = {
    enable = mkEnableOption "fuzzel";
  };

  config = mkIf cfg.enable {
    hm.programs.fuzzel = {
      enable = true;

      settings = {
        main = {
          font = "${config.mine.fonts.terminal.name} Semibold:size=${toString config.mine.fonts.size}";
          terminal = config.vars.terminal;
          icon-theme = config.mine.theme.gtk.theme.name;
          icons-enabled = "yes";
          inner-pad = 15;
          layer = "overlay";
          dpi-aware = "auto";
          exit-on-keyboard-focus-loss = "no";
          fields = "filename,name,generic";
          use-bold = "yes";
          prompt = "->";
          width = 50;
          launch-prefix = if config.mine.hyprland.withUWSM then "${app2unit} --fuzzel-compat --" else null;
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
