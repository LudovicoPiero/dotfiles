{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkOption types mkIf;
  cfg = config.mine.mako;
  c = config.mine.theme.colors;
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
        background-color=${c.base00}
        border-color=${c.base0D}
        text-color=${c.base05}
        progress-color=over ${c.base02}

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
