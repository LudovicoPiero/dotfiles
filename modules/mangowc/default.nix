{
  config,
  lib,
  inputs',
  ...
}:
let
  inherit (lib)
    mkOption
    types
    mkIf
    mkMerge
    ;
  cfg = config.mine.mangowc;
in
{
  options.mine.mangowc = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable mangowc.";
    };

    package = mkOption {
      type = types.package;
      inherit (inputs'.mangowc.packages) default;
      description = "The mangowc package to install.";
    };

    withUWSM = mkOption {
      type = types.bool;
      default = true;
      description = "Whether to use UWSM for session management.";
    };
  };

  config = mkIf cfg.enable (mkMerge [
    (mkIf cfg.withUWSM {
      programs.uwsm = {
        enable = true;
        waylandCompositors.mangowc = {
          binPath = "/etc/profiles/per-user/lain/bin/mango";
          prettyName = "Mangowc";
          comment = "Mangowc managed by UWSM";
        };
      };

      environment = {
        etc."greetd/environments".text = lib.mkBefore "uwsm start mangowc-uwsm.desktop";
        sessionVariables = {
          APP2UNIT_SLICES = "a=app-graphical.slice b=background-graphical.slice s=session-graphical.slice";
          APP2UNIT_TYPE = "scope";
        };
      };
    })
  ]);
}
