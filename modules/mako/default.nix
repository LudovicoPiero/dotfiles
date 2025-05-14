{
  lib,
  pkgs,
  config,
  palette,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.myOptions.mako;
in
{
  options.myOptions.mako = {
    enable = mkEnableOption "mako service";
  };

  config = mkIf cfg.enable {
    hj = {
      packages = with pkgs; [
        libnotify
        mako
      ];

      files.".config/mako/config".text = ''
        font=${config.myOptions.fonts.terminal.name} ${toString config.myOptions.fonts.size}
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
        height=100
        width=300
      '';
    };
  };
}
