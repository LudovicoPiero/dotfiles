{ lib, config, ... }:
let
  inherit (lib) mkEnableOption mkIf;
in
{
  options.myOptions.sddm = {
    enable = mkEnableOption "sddm" // {
      default = config.vars.withGui;
    };
  };

  config = mkIf config.vars.withGui {
    security = {
      pam.services.sddm.enableGnomeKeyring = true;
    };

    services.displayManager.sddm = {
      enable = true;
      wayland.enable = true;
    };
  };
}
