{ lib, config, ... }:
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
    home-manager.users.${config.vars.username} =
      { config, osConfig, ... }:
      let
        inherit (config.colorScheme) palette;
      in
      {
        programs.fuzzel = {
          enable = true;
          settings = {
            main = {
              font = "${osConfig.myOptions.fonts.terminal.name} Semibold-${toString osConfig.myOptions.fonts.size}";
              terminal = "wezterm";
              icon-theme = "${config.gtk.iconTheme.name}";
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
      }; # For Home-Manager options
  };
}
