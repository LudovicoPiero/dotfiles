{ lib, config, ... }:
let
  inherit (lib) mkMerge mkIf optional;

  # Helper for Native Messaging
  mkNativeHosts =
    slug:
    let
      cfg = config.mine.programs.${slug};
    in
    mkIf cfg.enable {
      mine.mozilla.firefoxNativeMessagingHosts =
        cfg.nativeMessagingHosts
        ++ (optional (cfg.finalPackage != null) cfg.finalPackage);
    };
in
{
  config = mkMerge [
    (mkNativeHosts "firefox")
    (mkNativeHosts "zen-browser")
  ];
}
