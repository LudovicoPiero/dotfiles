{
  lib,
  pkgs,
  config,
  inputs,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    mkIf
    ;

  cfg = config.myOptions.firefox;
in
{
  options.myOptions.firefox = {
    enable = mkEnableOption "firefox browser" // {
      default = config.myOptions.vars.withGui;
    };
  };

  config = mkIf cfg.enable {
    home-manager.users.${config.myOptions.vars.username} =
      { osConfig, ... }:
      {
        programs.firefox = {
          enable = true;
          package = pkgs.firefox;

          profiles = {
            ludovico =
              {
                id = 0;
                isDefault = true;
                name = "Ludovico";
                extensions = import ./extensions.nix { inherit inputs pkgs; };
                bookmarks = import ./bookmarks.nix;
                search = import ./search.nix { inherit pkgs; };
                settings = import ./settings.nix { inherit lib osConfig; };
              }
              // (
                let
                  inherit (inputs.ludovico-nixpkgs.packages.${pkgs.stdenv.hostPlatform.system}) firefox-gnome-theme;
                  betterfox = pkgs.fetchFromGitHub {
                    owner = "yokoffing";
                    repo = "Betterfox";
                    rev = "135.0";
                    hash = "sha256-5fD8ffAyIgQYJ0Z/bMEpqf17YghVQNaK+giZ1Tyk6/Q=";
                  };
                in
                {
                  userChrome = ''@import "${firefox-gnome-theme}/userChrome.css";'';
                  userContent = ''@import "${firefox-gnome-theme}/userContent.css";'';
                  extraConfig = ''
                    ${builtins.readFile "${firefox-gnome-theme}/configuration/user.js"}
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
                    user_pref("gnomeTheme.hideSingleTab", false);
                    user_pref("gnomeTheme.bookmarksToolbarUnderTabs", true);
                    user_pref("gnomeTheme.hideWebrtcIndicator", true);
                    user_pref("gnomeTheme.systemIcons", true);
                  '';
                }
              );
          };
        };
      };
  };
}
