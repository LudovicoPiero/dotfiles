{ lib, config, ... }:
let
  inherit (lib) mkEnableOption mkIf mkMerge;
in
{
  options.myOptions.sddm = {
    enable = mkEnableOption "sddm" // {
      default = config.vars.withGui;
    };
  };

  config = mkMerge [
    (mkIf config.vars.withGui {
      security = {
        pam.services.sddm.enableGnomeKeyring = true;
      };

      services.displayManager.sddm = {
        enable = true;
        wayland.enable = true;
      };
    })

    (mkIf (!config.vars.withGui) { services.getty.autologinUser = "${config.vars.username}"; })
  ];
}
