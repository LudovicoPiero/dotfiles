{
  lib,
  pkgs,
  config,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    mkIf
    getExe
    getExe'
    ;
  cfg = config.mine.cliphist;
in
{
  options.mine.cliphist = {
    enable = mkEnableOption "clipboard history manager (cliphist)";
  };

  config = mkIf cfg.enable {
    # Installs packages required for clipboard management and history access
    environment.systemPackages = [
      pkgs.cliphist
      pkgs.wl-clipboard
    ];

    systemd.user.services.cliphist = {
      description = "Clipboard history manager";

      # Starts after the graphical session is established
      after = [ "graphical-session.target" ];
      partOf = [ "graphical-session.target" ];
      wantedBy = [ "graphical-session.target" ];

      serviceConfig = {
        # Watches clipboard for text changes and stores them
        ExecStart = "${getExe' pkgs.wl-clipboard "wl-paste"} --watch ${getExe pkgs.cliphist} store";
        Restart = "always";
        RestartSec = "1s";
      };
    };

    # Enables image support for clipboard history
    systemd.user.services.cliphist-images = {
      description = "Clipboard history manager (Images)";
      after = [ "graphical-session.target" ];
      partOf = [ "graphical-session.target" ];
      wantedBy = [ "graphical-session.target" ];

      serviceConfig = {
        # Watches clipboard for image changes and stores them
        ExecStart = "${getExe' pkgs.wl-clipboard "wl-paste"} --type image --watch ${getExe pkgs.cliphist} store";
        Restart = "always";
        RestartSec = "1s";
      };
    };
  };
}
