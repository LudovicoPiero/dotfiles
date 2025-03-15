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
    ;

  cfg = config.myOptions.keyring;
in
{
  options.myOptions.keyring = {
    enable = mkEnableOption "keyring" // {
      default = config.vars.withGui;
    };
  };

  config = mkIf cfg.enable {
    environment = {
      systemPackages = [ pkgs.libsecret ];
      variables.XDG_RUNTIME_DIR = "/run/user/${toString config.users.users.airi.uid}"; # set the runtime directory
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

    systemd.packages = [ pkgs.hyprpolkitagent ];
    systemd.user.services.hyprpolkitagent = {
      wantedBy = [ "graphical-session.target" ];
      wants = [ "graphical-session.target" ];
      after = [ "graphical-session.target" ];
    };
  };
}
