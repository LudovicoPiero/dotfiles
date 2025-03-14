{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    mkIf
    mkMerge
    ;

  _ = lib.getExe;
  swayConf = pkgs.writeText "greetd-sway-config" ''
    output eDP-1 disable
    exec "${pkgs.greetd.gtkgreet}/bin/gtkgreet -l; swaymsg exit"

    bindsym Mod4+shift+e exec swaynag \
      -t warning \
      -m 'What do you want to do?' \
      -b 'Poweroff' 'systemctl poweroff' \
      -b 'Reboot' 'systemctl reboot'
  '';
in
{
  options.myOptions.greetd = {
    enable = mkEnableOption "greetd service" // {
      default = true;
    };
  };

  config = mkMerge [
    (mkIf config.myOptions.vars.withGui {
      security = {
        pam.services.greetd.enableGnomeKeyring = true;
      };

      environment.etc."greetd/environments".text = ''
        ${lib.getExe config.programs.uwsm.package} start hyprland-uwsm.desktop
      '';

      services.greetd = {
        enable = true;
        settings = {
          terminal.vt = 7;
          default_session = {
            command = "${_ pkgs.sway} --config ${swayConf}";
            # command = "${_ pkgs.cage} -s -- ${_ pkgs.greetd.gtkgreet} -l";
            user = "${config.myOptions.vars.username}";
          };
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
