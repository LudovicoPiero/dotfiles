{ lib, config, ... }:
let
  inherit (lib) mkRemovedOptionModule;

  cfg = config.mine.programs.zen-browser;

  modulePath = [
    "mine"
    "programs"
    "zen-browser"
  ];

  moduleName = lib.concatStringsSep "." modulePath;

  mkFirefoxModule = import ./_mkFirefoxModule.nix;
in
{
  imports = [
    (mkFirefoxModule {
      inherit modulePath;
      name = "zen-browser";
      wrappedPackageName = "zen-browser";
      unwrappedPackageName = "zen-browser-unwrapped";
      visible = true;

      platforms.linux = {
        configPath = ".zen";
      };
      # platforms.darwin = {
      #   configPath = "Library/Application Support/Firefox";
      #   defaultsId = "org.mozilla.firefox.plist";
      # };
    })

    (mkRemovedOptionModule (modulePath ++ [ "extensions" ]) ''
      Extensions are now managed per-profile. That is, change from

        ${moduleName}.extensions = [ foo bar ];

      to

        ${moduleName}.profiles.myprofile.extensions.packages = [ foo bar ];'')
    (mkRemovedOptionModule (
      modulePath ++ [ "enableAdobeFlash" ]
    ) "Support for this option has been removed.")
    (mkRemovedOptionModule (
      modulePath ++ [ "enableGoogleTalk" ]
    ) "Support for this option has been removed.")
    (mkRemovedOptionModule (
      modulePath ++ [ "enableIcedTea" ]
    ) "Support for this option has been removed.")
  ];

  config = lib.mkIf cfg.enable {
    mine.mozilla.firefoxNativeMessagingHosts =
      cfg.nativeMessagingHosts
      # package configured native messaging hosts (entire browser actually)
      ++ (lib.optional (cfg.finalPackage != null) cfg.finalPackage);
  };
}
