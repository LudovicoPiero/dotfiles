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
            duckduckgo-privacy-essentials
            i-dont-care-about-cookies
            to-deepl
            ublock-origin
            # fastforward
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
            duckduckgo-privacy-essentials
            i-dont-care-about-cookies
            to-deepl
            ublock-origin
          ];
          search = import ./search.nix {inherit pkgs;};
          settings = import ./settings-schizo.nix;
        }
        // (let
          inherit (config.nur.repos.federicoschonborn) firefox-gnome-theme;
        in {
          userChrome = ''@import "${firefox-gnome-theme}/userChrome.css";'';
          userContent = ''@import "${firefox-gnome-theme}/userContent.css";'';
          extraConfig = builtins.readFile "${firefox-gnome-theme}/configuration/user.js";
        });
    };
  };
}
