{
  pkgs,
  config,
  ...
}: {
  programs.firefox = {
    enable = true;
    profiles = {
      ludovico =
        {
          id = 0;
          isDefault = true;
          name = "Ludovico";
          extensions = with config.nur.repos.rycee.firefox-addons; [
            bitwarden
            faststream
            notifier-for-github
            refined-github
            skip-redirect
            sponsorblock
            to-deepl
            ublock-origin
          ];
          bookmarks = import ./bookmarks.nix;
          search = import ./search.nix {inherit pkgs;};
          settings = import ./settings.nix;
        }
        // (let
          inherit (config.nur.repos.federicoschonborn) firefox-gnome-theme;
        in {
          userChrome = ''@import "${firefox-gnome-theme}/userChrome.css";'';
          userContent = ''@import "${firefox-gnome-theme}/userContent.css";'';
          extraConfig = builtins.readFile "${firefox-gnome-theme}/configuration/user.js";
        });

      schizo =
        {
          id = 1;
          isDefault = false;
          name = "Schizo";
          extensions = with config.nur.repos.rycee.firefox-addons; [
            bitwarden
            i-dont-care-about-cookies
            skip-redirect
            ublock-origin
            fastforwardteam
          ];
          search = import ./search.nix {inherit pkgs;};
        }
        // (let
          inherit (config.nur.repos.federicoschonborn) firefox-gnome-theme;
          betterfox = pkgs.fetchFromGitHub {
            owner = "yokoffing";
            repo = "Betterfox";
            rev = "119.0";
            hash = "sha256-FX5y7fmxTcyB5aVb1IDOwhZPRB/VyqPaIVabMuiOrv8=";
          };
        in {
          userChrome = ''@import "${firefox-gnome-theme}/userChrome.css";'';
          userContent = ''@import "${firefox-gnome-theme}/userContent.css";'';
          extraConfig = ''
            ${builtins.readFile "${firefox-gnome-theme}/configuration/user.js"}
            ${builtins.readFile "${betterfox}/Fastfox.js"}
            ${builtins.readFile "${betterfox}/Peskyfox.js"}
            ${builtins.readFile "${betterfox}/Securefox.js"}
            ${builtins.readFile "${betterfox}/Smoothfox.js"}

            /* Custom User.js */
            user_pref("browser.tabs.firefox-view-next", false);
            user_pref("privacy.sanitize.sanitizeOnShutdown", false);
            user_pref("privacy.clearOnShutdown.cache", false);
            user_pref("privacy.clearOnShutdown.cookies", false);
            user_pref("privacy.clearOnShutdown.offlineApps", false);
            user_pref("browser.sessionstore.privacy_level", 0);
            user_pref("network.trr.uri", "https://dns.quad9.net/dns-query");
            user_pref("network.trr.mode", 3);
            user_pref("gnomeTheme.hideSingleTab", false);
            user_pref("gnomeTheme.bookmarksToolbarUnderTabs", true);
            user_pref("gnomeTheme.hideWebrtcIndicator", true);
            user_pref("gnomeTheme.systemIcons", true);
          '';
        });
    };
  };
}
