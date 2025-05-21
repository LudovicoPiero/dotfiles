{
  lib,
  pkgs,
  config,
  ...
}:
let
  inherit (lib) mkEnableOption mkPackageOption mkIf;
  inherit (config.mine.theme.colorScheme) palette;

  cfg = config.mine.mako;
in
{
  options.mine.mako = {
    enable = mkEnableOption "mako service";

    package = mkPackageOption pkgs "mako" { };
  };

  config = mkIf cfg.enable {
    hj = {
      packages = with pkgs; [
        libnotify
        cfg.package
      ];

      files.".config/mako/config".text = ''
        font=${config.mine.fonts.terminal.name} ${toString config.mine.fonts.size}
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

    systemd.user.services.mako = {
      enable = true;
      description = "Wayland notification daemon";
      after = [ "graphical-session.target" ];
      wantedBy = [ "graphical-session.target" ];
      bindsTo = [ "graphical-session.target" ];
      serviceConfig = {
        Type = "simple";
        Restart = "on-failure";
        ExecStart = "${lib.getExe cfg.package}";
      };
    };
  };
}
