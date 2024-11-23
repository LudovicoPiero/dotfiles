{
  lib,
  pkgs,
  config,
  ...
}: let
  inherit
    (lib)
    mkEnableOption
    mkIf
    mkOption
    types
    ;

  cfg = config.myOptions.keyring;
in {
  options.myOptions.keyring = {
    enable =
      mkEnableOption "keyring"
      // {
        default = config.myOptions.vars.withGui;
      };
  };

  config = mkIf cfg.enable {
    environment = {
      systemPackages = [pkgs.libsecret];
      variables.XDG_RUNTIME_DIR = "/run/user/${toString config.users.users.airi.uid}"; # set the runtime directory
    };
    programs.dconf.enable = true;
    # Fixes the org.a11y.Bus not provided by .service file error
    services = {
      gnome.at-spi2-core.enable = true;
      gnome.gnome-keyring.enable = true;
      dbus.packages = [pkgs.seahorse];
    };
    security.polkit.enable = true;

    systemd = {
      user.services.pantheon-agent-polkit = {
        description = "pantheon-agent-polkit";
        wantedBy = ["graphical-session.target"];
        wants = ["graphical-session.target"];
        after = ["graphical-session.target"];
        serviceConfig = {
          Type = "simple";
          ExecStart = "${pkgs.pantheon.pantheon-agent-polkit}/libexec/policykit-1-pantheon/io.elementary.desktop.agent-polkit";
          Restart = "on-failure";
          RestartSec = 1;
          TimeoutStopSec = 10;
        };
      };
    };
  };
}
