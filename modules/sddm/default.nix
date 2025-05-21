{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf mkMerge;
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

      services.displayManager.sddm = {
        enable = true;
        package = lib.mkForce (
          pkgs.kdePackages.sddm.overrideAttrs (old: {
            patches = (old.patches or [ ]) ++ [
              (pkgs.fetchpatch {
                url = "https://patch-diff.githubusercontent.com/raw/sddm/sddm/pull/1779.patch";
                hash = "sha256-8QP9Y8V9s8xrc+MIUlB7iHVNHbntGkw0O/N510gQ+bE=";
              })
            ];
          })
        );

        wayland.enable = true;
        theme = lib.mkForce "";
      };
    })

    (mkIf (!config.vars.withGui) { services.getty.autologinUser = "${config.vars.username}"; })
  ];
}
