{ pkgs, inputs, ... }:
{
  programs.firefox = {
    enable = true;

    profiles = {
      ludovico =
        {
          id = 0;
          isDefault = true;
          name = "Ludovico";
          extensions = with inputs.firefox-addons.packages.${pkgs.stdenv.hostPlatform.system}; [
            bitwarden
            refined-github
            sponsorblock
            to-deepl
            ublock-origin
          ];
          bookmarks = import ./__bookmarks.nix;
          search = import ./__search.nix { inherit pkgs; };
          settings = import ./__settings.nix;
        }
        // (
          let
            inherit (inputs.ludovico-nixpkgs.packages.${pkgs.stdenv.hostPlatform.system}) firefox-gnome-theme;
            betterfox = pkgs.fetchFromGitHub {
              owner = "yokoffing";
              repo = "Betterfox";
              rev = "126.0";
              hash = "sha256-W0JUT3y55ro3yU23gynQSIu2/vDMVHX1TfexHj1Hv7Q=";
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
}
