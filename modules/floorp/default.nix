{
  lib,
  pkgs,
  config,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.myOptions.floorp;
in
{
  options.myOptions.floorp = {
    enable = mkEnableOption "floorp" // {
      default = config.vars.withGui;
    };
  };

  config = mkIf cfg.enable {
    home-manager.users.${config.vars.username} = {
      imports = [
        ./extensions.nix
        ./bookmarks.nix
        ./search.nix
        ./settings.nix
      ];

      programs.floorp = {
        enable = true;

        profiles = {
          ludovico =
            {
              id = 0;
              isDefault = true;
              name = "Ludovico";
            }
            // (
              let
                betterfox = pkgs.fetchFromGitHub {
                  owner = "yokoffing";
                  repo = "Betterfox";
                  rev = "135.0";
                  hash = "sha256-5fD8ffAyIgQYJ0Z/bMEpqf17YghVQNaK+giZ1Tyk6/Q=";
                };
                lepton = pkgs.fetchFromGitHub {
                  owner = "black7375";
                  repo = "Firefox-UI-Fix";
                  rev = "v8.7.0";
                  hash = "sha256-NBPSKIxTNSuJahySyLqD45R/UmeyvkJBKehUIE/dI0I=";
                };
              in
              {
                userChrome = ''@import "${lepton}/css/leptonChromeESR.css";'';
                userContent = ''@import "${lepton}/css/leptonContentESR.css";'';
                extraConfig = ''
                  ${builtins.readFile "${lepton}/user.js"}
                  ${builtins.readFile "${betterfox}/user.js"}
                  ${builtins.readFile "${betterfox}/Fastfox.js"}
                  ${builtins.readFile "${betterfox}/Peskyfox.js"}
                  ${builtins.readFile "${betterfox}/Securefox.js"}
                  ${builtins.readFile "${betterfox}/Smoothfox.js"}

                  /* Betterfox overrides */
                  // PREF: disable address and credit card manager
                  user_pref("extensions.formautofill.addresses.enabled", false);
                  user_pref("extensions.formautofill.creditCards.enabled", false);

                  // PREF: enable HTTPS-Only Mode
                  // Warn me before loading sites that don't support HTTPS
                  // when using Private Browsing windows.
                  user_pref("dom.security.https_only_mode_pbm", true);
                  user_pref("dom.security.https_only_mode_error_page_user_suggestions", true);

                  // PREF: disable Firefox Sync
                  user_pref("identity.fxaccounts.enabled", false);

                  // PREF: disable the Firefox View tour from popping up
                  user_pref("browser.firefox-view.feature-tour", "{\"screen\":\"\",\"complete\":true}");

                  // Fix Strict ETP issue
                  user_pref("browser.contentblocking.category", "standard");

                  /* Custom User.js */
                  user_pref("browser.tabs.firefox-view-next", false);
                  user_pref("privacy.sanitize.sanitizeOnShutdown", false);
                  user_pref("privacy.clearOnShutdown.cache", false);
                  user_pref("privacy.clearOnShutdown.cookies", false);
                  user_pref("privacy.clearOnShutdown.offlineApps", false);
                  user_pref("browser.sessionstore.privacy_level", 0);
                  user_pref("floorp.browser.sidebar.enable", false);
                  user_pref("geo.enabled", false);
                  user_pref("media.navigator.enabled", false);
                  user_pref("dom.event.clipboardevents.enabled", false);
                  user_pref("dom.event.contextmenu.enabled", false);
                  user_pref("dom.battery.enabled", false);
                '';
              }
            );
        };
      };
    };
  };
}
