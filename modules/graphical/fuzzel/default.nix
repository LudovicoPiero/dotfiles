{
  config,
  lib,
  userName,
  ...
}:
let
  cfg = config.mine.fuzzel;
  inherit (config.colorScheme) palette;
  inherit (lib) mkIf mkOption types;
in
{
  options.mine.fuzzel = {
    enable = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Enable fuzzel Shell and Set configuration.
      '';
    };
  };

  config = mkIf cfg.enable {
    home-manager.users.${userName} = {
      programs.fuzzel = {
        enable = true;
        settings = {
          main = {
            font = "Iosevka q SemiBold-16";
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
    };
  };
}
