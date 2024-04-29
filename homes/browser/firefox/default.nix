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
        };

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
        };
    };
  };
}
