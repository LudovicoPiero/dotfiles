{
  lib,
  pkgs,
  config,
  inputs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.myOptions.firefox;
in
{
  options.myOptions.firefox = {
    enable = mkEnableOption "firefox browser" // {
      default = config.vars.withGui;
    };
  };

  config = mkIf cfg.enable {
    home-manager.users.${config.vars.username} = {
      imports = [
        ./settings.nix
        ./search.nix
        ./bookmarks.nix
        ./extensions.nix
      ];

      programs.firefox = {
        enable = true;
        package = pkgs.firefox;

        profiles = {
          ludovico =
            {
              id = 0;
              isDefault = true;
              name = "Ludovico";
            }
            // (
              let
                inherit (inputs.self.packages.${pkgs.stdenv.hostPlatform.system}) firefox-gnome-theme;
              in
              {
                userChrome = ''@import "${firefox-gnome-theme}/userChrome.css";'';
                userContent = ''@import "${firefox-gnome-theme}/userContent.css";'';
                extraConfig = ''
                  // user_pref("extensions.formautofill.addresses.enabled", false);
                  // user_pref("extensions.formautofill.creditCards.enabled", false);

                  // // PREF: enable HTTPS-Only Mode
                  // // Warn me before loading sites that don't support HTTPS
                  // // when using Private Browsing windows.
                  // user_pref("dom.security.https_only_mode_pbm", true);
                  // user_pref("dom.security.https_only_mode_error_page_user_suggestions", true);

                  // // PREF: disable the Firefox View tour from popping up
                  // user_pref("browser.firefox-view.feature-tour", "{\"screen\":\"\",\"complete\":true}");

                  // // Fix Strict ETP issue
                  // user_pref("browser.contentblocking.category", "standard");

                  /* Custom User.js */
                  user_pref("privacy.sanitize.sanitizeOnShutdown", false);
                  user_pref("privacy.clearOnShutdown.cache", false);
                  user_pref("privacy.clearOnShutdown.cookies", false);
                  user_pref("privacy.clearOnShutdown.offlineApps", false);
                  user_pref("browser.sessionstore.privacy_level", 0);
                '';
              }
            );
        };
      };
    };
  };
}
