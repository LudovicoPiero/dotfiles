{ config, lib, ... }:
let
  inherit (lib) mkOption types mkIf;
  cfg = config.mine.greetd;
in
{
  options.mine.greetd = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable greetd.";
    };
  };

  config = mkIf cfg.enable {
    services.greetd = {
      enable = true;
      settings = rec {
        initial_session = {
          command = "uwsm start hyprland-uwsm.desktop";
          user = "${config.vars.username}";
        };
        default_session = initial_session;
      };
    };
  };
}
