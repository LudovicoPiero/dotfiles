{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.mine.gnome;
  inherit (lib)
    mkIf
    mkOption
    mkMerge
    types
    ;
in
{
  options.mine.gnome = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Enable GNOME Programs
      '';
    };

    keyring = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Enable GNOME Keyring
        '';
      };
    };
  };

  config = mkIf cfg.enable (
    mkMerge [
      {
        programs.dconf.enable = true;
        # Fixes the org.a11y.Bus not provided by .service file error
        services.gnome.at-spi2-core.enable = true;
      }
      (mkIf cfg.keyring.enable {
        services.gnome.gnome-keyring.enable = true;
        environment.systemPackages = [ pkgs.libsecret ];
        services.dbus.packages = [ pkgs.gnome.seahorse ];

        systemd = {
          user.services.pantheon-agent-polkit = {
            description = "pantheon-agent-polkit";
            wantedBy = [ "graphical-session.target" ];
            wants = [ "graphical-session.target" ];
            after = [ "graphical-session.target" ];
            serviceConfig = {
              Type = "simple";
              ExecStart = "${pkgs.pantheon.pantheon-agent-polkit}/libexec/policykit-1-pantheon/io.elementary.desktop.agent-polkit";
              Restart = "on-failure";
              RestartSec = 1;
              TimeoutStopSec = 10;
            };
          };
        };
      })
    ]
  );
}
