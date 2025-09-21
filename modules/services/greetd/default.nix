{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf mkMerge;

  _ = lib.getExe;

  # For Autologin
  # session = {
  #   command = "${_ config.programs.uwsm.package} start hyprland-uwsm.desktop";
  #   user = "${config.vars.username}";
  # };

  # swayConf = pkgs.writeText "greetd-sway-config" ''
  #   exec "${_ pkgs.gtkgreet} -l; swaymsg exit"
  #
  #   bindsym Mod4+shift+e exec swaynag \
  #     -t warning \
  #     -m 'What do you want to do?' \
  #     -b 'Poweroff' 'systemctl poweroff' \
  #     -b 'Reboot' 'systemctl reboot'
  # '';
in
{
  options.mine.greetd = {
    enable = mkEnableOption "Greetd Service";
  };

  config = mkMerge [
    (mkIf config.vars.withGui {
      security.pam.services = {
        greetd.enableGnomeKeyring = true;
        greetd.enableKwallet = true;
        greetd.gnupg.enable = true;
      };

      services.greetd = {
        enable = true;
        settings = {
          terminal.vt = 1;
          default_session = {
            # command = "${_ pkgs.sway} --config ${swayConf}";
            command = "${_ pkgs.cage} -s -- ${_ pkgs.gtkgreet} -l";
            user = "greeter";
          };
        };
      };

      programs.uwsm = {
        enable = true;
      };
    })

    (mkIf (!config.vars.withGui) { services.getty.autologinUser = "${config.mine.vars.username}"; })
  ];
}
