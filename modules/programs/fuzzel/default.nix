{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkOption types mkIf;
  inherit (config.mine.theme.colorScheme) palette;
  cfg = config.mine.fuzzel;
in
{
  options.mine.fuzzel = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable fuzzel.";
    };
  };

  config = mkIf cfg.enable {
    hj = {
      packages = [ pkgs.fuzzel ];
      xdg.config.files."fuzzel/fuzzel.ini".text = ''
        font="${config.mine.fonts.terminal.name}:size=${toString config.mine.fonts.size}"
        icon-theme="${config.mine.theme.gtk.theme.name}"
        icons-enabled=yes
        inner-pad=15
        layer=overlay
        launch-prefix=${
          if config.mine.hyprland.withUWSM then "uwsm app --" else null
        }
        dpi-aware=auto
        exit-on-keyboard-focus-loss=no
        fields="filename,name,generic"
        use-bold=yes
        prompt="->"
        width=50

        [border]
        width=2
        radius=0

        [dmenu]
        mode=text

        [colors]
        background=${palette.base00}f2
        text=${palette.base05}ff
        match=${palette.base0A}ff
        selection=${palette.base03}ff
        selection-text=${palette.base05}ff
        selection-match=${palette.base0A}ff
        border=${palette.base0D}ff
      '';
    };

  };
}
