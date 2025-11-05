{
  mine.programs.zen-browser.profiles.ludovico.bookmarks = {
    force = true;
    settings = [
      {
        name = "ANIME"; # Bookmark Folder
        toolbar = true;
        bookmarks = [
          {
            name = "ANIMEPAHE";
            keyword = "ah";
            url = "https://animepahe.ru";
          }
          {
            name = "KICKASSANIME";
            keyword = "kaa";
            url = "https://kaa.mx";
          }
        ];
      }
      {
        name = "NixOS";
        toolbar = true;
        bookmarks = [
          {
            name = "Nix Package";
            keyword = "np";
            url = "https://search.nixos.org/packages?channel=unstable";
          }
          {
            name = "Nix Options";
            keyword = "no";
            url = "https://search.nixos.org/options?channel=unstable";
          }
          {
            name = "NixOS Wiki";
            keyword = "nw";
            url = "https://wiki.nixos.org/wiki/Linux_kernel";
          }
          {
            name = "Home-Manager";
            keyword = "hm";
            url = "https://nix-community.github.io/home-manager/options.xhtml";
          }
        ];
      }
      {
        name = "1337";
        toolbar = true;
        bookmarks = [
          {
            name = "GitHub";
            keyword = "gh";
            url = "https://github.com";
          }
          {
            name = "GitLab";
            keyword = "gl";
            url = "https://gitlab.com";
          }
          {
            name = "SourceHut";
            keyword = "sh";
            url = "https://git.sr.ht";
          }
        ];
      }
      {
        name = "lol";
        toolbar = false;
        bookmarks = [
          {
            name = "Google";
            keyword = "g";
            url = "https://google.com";
          }
          {
            name = "DuckDuckGo";
            keyword = "dg";
            url = "https://DuckDuckGo.com";
          }
          {
            name = "Twitter";
            keyword = "x";
            url = "https://x.com";
          }
          {
            name = "YouTube";
            keyword = "yt";
            url = "https://YouTube.com";
          }
        ];
      }
    ];
  };
}
