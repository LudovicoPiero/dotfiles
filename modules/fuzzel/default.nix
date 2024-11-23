{
  lib,
  pkgs,
  config,
  ...
}: let
  inherit
    (lib)
    mkEnableOption
    mkIf
    mkOption
    types
    ;

  cfg = config.myOptions.fuzzel;
in {
  options.myOptions.fuzzel = {
    enable =
      mkEnableOption "fuzzel"
      // {
        default = config.myOptions.vars.withGui;
      };
  };

  config = mkIf cfg.enable {
    home-manager.users.${config.myOptions.vars.username} = {
      config,
      osConfig,
      ...
    }: let
      inherit (config.colorScheme) palette;
    in {
      programs.fuzzel = {
        enable = true;
        settings = {
          main = {
            font = "${osConfig.myOptions.vars.mainFont}-16";
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
