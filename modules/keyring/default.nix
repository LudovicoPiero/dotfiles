{
  lib,
  pkgs,
  config,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.myOptions.keyring;
in
{
  options.myOptions.keyring = {
    enable = mkEnableOption "keyring";
  };

  config = mkIf cfg.enable {
    environment = {
      systemPackages = [ pkgs.libsecret ];
    };
    programs.dconf.enable = true;
    # Fixes the org.a11y.Bus not provided by .service file error
    services = {
      gnome.at-spi2-core.enable = true;
      gnome.gnome-keyring.enable = true;
      dbus.packages = with pkgs; [
        gcr
        seahorse
      ];
    };
    security.polkit.enable = true;

    systemd.user.services.hyprpolkitagent = {
      enable = true;
      description = "Polkit authentication agent";
      after = [ "graphical-session.target" ];
      wantedBy = [ "graphical-session.target" ];
      bindsTo = [ "graphical-session.target" ];
      serviceConfig = {
        Type = "simple";
        Restart = "on-failure";
        ExecStart = "${lib.getExe pkgs.hyprpolkitagent}";
      };
    };
  };
}
