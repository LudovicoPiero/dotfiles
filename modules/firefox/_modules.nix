{ lib, config, ... }:
let
  inherit (lib) mkRemovedOptionModule;

  cfg = config.mine.programs.firefox;

  modulePath = [
    "mine"
    "programs"
    "firefox"
  ];

  moduleName = lib.concatStringsSep "." modulePath;

  mkFirefoxModule = import ./_mkFirefoxModule.nix;
in
{
  imports = [
    (mkFirefoxModule {
      inherit modulePath;
      name = "Firefox";
      wrappedPackageName = "firefox";
      unwrappedPackageName = "firefox-unwrapped";
      visible = true;

      platforms.linux = {
        configPath = ".mozilla/firefox";
      };
      platforms.darwin = {
        configPath = "Library/Application Support/Firefox";
        defaultsId = "org.mozilla.firefox.plist";
      };
    })

    (mkRemovedOptionModule (modulePath ++ [ "extensions" ]) ''
      Extensions are now managed per-profile. That is, change from

        ${moduleName}.extensions = [ foo bar ];

      to

        ${moduleName}.profiles.myprofile.extensions.packages = [ foo bar ];'')
  ];

  config = lib.mkIf cfg.enable {
    mine.mozilla.firefoxNativeMessagingHosts =
      cfg.nativeMessagingHosts
      # package configured native messaging hosts (entire browser actually)
      ++ (lib.optional (cfg.finalPackage != null) cfg.finalPackage);
  };
}
