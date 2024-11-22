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

  session = {
    command = "${lib.getExe config.programs.uwsm.package} start hyprland-uwsm.desktop";
    user = "${config.myOptions.vars.username}";
  };

  cfg = config.myOptions.greetd;
in {
  options.myOptions.greetd = {
    enable =
      mkEnableOption "greetd service"
      // {
        default = config.myOptions.vars.withGui;
      };
  };

  config = mkIf cfg.enable {
    security = {
      pam.services.greetd.enableGnomeKeyring = true;
    };

    services.greetd = {
      enable = true;
      settings = {
        terminal.vt = 1;
        default_session = session;
        initial_session = session;
      };
    };

    programs.uwsm = {
      enable = true;
      waylandCompositors.hyprland = {
        binPath = "/run/current-system/sw/bin/Hyprland";
        prettyName = "Hyprland";
        comment = "Hyprland managed by UWSM";
      };
    };
  };
}
