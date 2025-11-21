{
  lib,
  pkgs,
  config,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  inherit (config.mine.theme.colorScheme) palette;

  cfg = config.mine.mako;
  fontcfg = config.mine.fonts;
in
{
  options.mine.mako = {
    enable = mkEnableOption "mako service";
  };

  config = mkIf cfg.enable {
    hj = {
      packages = with pkgs; [
        libnotify
        mako
      ];

      xdg.config.files."mako/config".text = ''
        font=${fontcfg.terminal.name} ${toString fontcfg.size}
        background-color=#${palette.base00}
        border-color=#${palette.base0E}
        text-color=#${palette.base05}
        progress-color=over #${palette.base02}

        anchor=top-right
        border-radius=5
        border-size=2
        padding=20
        default-timeout=5000
        layer=top
        height=125
        width=400
      '';
    };
  };
}
