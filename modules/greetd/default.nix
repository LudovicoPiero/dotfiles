{
  lib,
  config,
  ...
}: let
  inherit
    (lib)
    mkEnableOption
    mkIf
    mkMerge
    ;

  session = {
    command = "${lib.getExe config.programs.uwsm.package} start hyprland-uwsm.desktop";
    user = "${config.myOptions.vars.username}";
  };
in {
  options.myOptions.greetd = {
    enable =
      mkEnableOption "greetd service"
      // {
        default = true;
      };
  };

  config = mkMerge [
    (mkIf config.myOptions.vars.withGui {
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
    })

    (mkIf (!config.myOptions.vars.withGui) {
      services.getty.autologinUser = "${config.myOptions.vars.username}";
    })
  ];
}
