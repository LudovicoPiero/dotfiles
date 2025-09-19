{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkForce
    mkEnableOption
    mkIf
    mkMerge
    ;
in
{
  options.mine.sddm = {
    enable = mkEnableOption "sddm service";
  };

  config = mkMerge [
    (mkIf config.vars.withGui {
      security = {
        pam.services.sddm.enableGnomeKeyring = true;
      };

      services.displayManager.gdm.enable = mkForce false;
      services.displayManager.sddm = {
        enable = true;

        wayland.enable = true;
        theme = lib.mkForce "";
      };
    })

    (mkIf (!config.vars.withGui) { services.getty.autologinUser = "${config.vars.username}"; })
  ];
}
