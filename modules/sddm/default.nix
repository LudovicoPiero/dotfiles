{ lib, config, ... }:
let
  inherit (lib) mkEnableOption mkIf mkMerge;
in
{
  options.myOptions.greetd = {
    enable = mkEnableOption "greetd service" // {
      default = true;
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
        theme = lib.mkForce "";
      };
    })

    (mkIf (!config.vars.withGui) { services.getty.autologinUser = "${config.vars.username}"; })
  ];
}
