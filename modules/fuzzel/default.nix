{
  lib,
  config,
  palette,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.myOptions.fuzzel;
in
{
  options.myOptions.fuzzel = {
    enable = mkEnableOption "fuzzel" // {
      default = config.myOptions.hyprland.enable;
    };
  };

  config = mkIf cfg.enable {
    hj.rum.programs.fuzzel = {
      enable = true;

      settings = {
        main = {
          font = "${config.myOptions.fonts.terminal.name} Semibold-${toString config.myOptions.fonts.size}";
          terminal = "wezterm";
          icon-theme = "WhiteSur-dark";
          prompt = "->";
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
