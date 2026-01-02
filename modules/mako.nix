{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkOption types mkIf;
  cfg = config.mine.mako;
in
{
  options.mine.mako = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable Mako configuration.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.mako;
      description = "The Mako package to install.";
    };
  };

  config = mkIf cfg.enable {
    hj = {
      packages = [ cfg.package ];
      xdg.config.files."mako/config".text = ''
        font=${config.mine.fonts.terminal.name} ${toString config.mine.fonts.size}
        background-color=#1e1e2e
        border-color=#cba6f7
        text-color=#cdd6f4
        progress-color=over #313244

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
