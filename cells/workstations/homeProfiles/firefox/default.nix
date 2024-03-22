{ pkgs, inputs, ... }:
{

  programs.firefox = {
    enable = true;
    # package = inputs.chaotic.packages.${pkgs.system}.firefox_nightly;

    profiles = {
      ludovico =
        {
          id = 0;
          isDefault = true;
          name = "Ludovico";
          extensions = with inputs.firefox-addons.packages.${pkgs.system}; [
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
            inherit (inputs.ludovico-nixpkgs.packages.${pkgs.system}) firefox-gnome-theme;
            betterfox = pkgs.fetchFromGitHub {
              owner = "yokoffing";
              repo = "Betterfox";
              rev = "120.0";
              hash = "sha256-ciNP1TLpxs/W08UhJg38tjPxtzhnRcjMyh+BwUsN2wA=";
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
