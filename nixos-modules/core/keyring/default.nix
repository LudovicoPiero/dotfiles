{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.mine.keyring;
  inherit (lib) mkIf mkOption types;
in {
  options.mine.keyring = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Enable gnome-keyring services.
      '';
    };
  };

  config = mkIf cfg.enable {
    services.gnome.gnome-keyring.enable = true;
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
