{
  lib,
  pkgs,
  config,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.mine.keyring;
in
{
  options.mine.keyring = {
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

    security = {
      polkit.enable = true;
      pam.services = {
        login.enableGnomeKeyring = true;
        greetd.enableGnomeKeyring = true;
        greetd.enableKwallet = true;
        greetd.gnupg.enable = true;
      };
    };

    systemd = {
      user.services.polkit-gnome-authentication-agent-1 = {
        description = "polkit-gnome-authentication-agent-1";
        wantedBy = [ "graphical-session.target" ];
        wants = [ "graphical-session.target" ];
        after = [ "graphical-session.target" ];
        serviceConfig = {
          Type = "simple";
          ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
          Restart = "on-failure";
          RestartSec = 1;
          TimeoutStopSec = 10;
        };
      };
    };
  };
}
