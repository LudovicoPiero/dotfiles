{
  lib,
  config,
  pkgs,
  inputs,
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
      services.greetd = {
        enable = true;
        settings = {
          terminal.vt = 1;
          default_session =
            let
              oldNixpkgs = inputs.nixpkgs-cage.legacyPackages.${pkgs.stdenv.hostPlatform.system};
            in
            {
              # command = "${_ pkgs.sway} --config ${swayConf}";
              command = "${_ oldNixpkgs.cage} -m last -s -- ${_ oldNixpkgs.gtkgreet} --layer-shell";
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
