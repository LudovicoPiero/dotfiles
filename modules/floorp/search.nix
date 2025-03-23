{ pkgs, ... }:
{
  programs.floorp.profiles.ludovico.search = {
    default = "ddg";
    order = [
      "ddg"
      "brave"
      "searx"
      "google"
    ];

    force = true;

    engines = {
      "searx" = {
        urls = [ { template = "https://opnxng.com/search?q={searchTerms}"; } ];
        definedAliases = [ "s" ];
      };

      "brave" = {
        urls = [ { template = "https://search.brave.com/search?q={searchTerms}"; } ];
        definedAliases = [ "b" ];
      };

      "ddg" = {
        urls = [ { template = "https://duckduckgo.com/?q={searchTerms}"; } ];
        definedAliases = [ "d" ];
      };

      "github" = {
        urls = [ { template = "https://github.com/search?q={searchTerms}&type=code"; } ];
        definedAliases = [ "gh" ];
      };

      "nix-packages" = {
        urls = [
          {
            template = "https://search.nixos.org/packages";
            params = [
              {
                name = "channel";
                value = "unstable";
              }
              {
                name = "type";
                value = "packages";
              }
              {
                name = "query";
                value = "{searchTerms}";
              }
            ];
          }
        ];

        icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
        definedAliases = [ "np" ];
      };

      "home-manager" = {
        urls = [ { template = "https://rycee.gitlab.io/home-manager/options.html"; } ];
        definedAliases = [ "hm" ];
      };

      "nixos-options" = {
        urls = [
          {
            template = "https://search.nixos.org/options";
            params = [
              {
                name = "channel";
                value = "unstable";
              }
              {
                name = "type";
                value = "packages";
              }
              {
                name = "query";
                value = "{searchTerms}";
              }
            ];
          }
        ];

        icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
        definedAliases = [ "no" ];
      };

      "nixos-wiki" = {
        urls = [ { template = "https://wiki.nixos.org/w/index.php?search={searchTerms}"; } ];
        icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
        definedAliases = [ "nw" ];
      };

      "youtube" = {
        urls = [ { template = "https://www.youtube.com/results?search_query={searchTerms}"; } ];
        definedAliases = [ "yt" ];
      };

      "amazondotcom-us".metaData.hidden = true;
      "bing".metaData.hidden = true;
      "ebay".metaData.hidden = true;
      "google".metaData.hidden = true;
      "google".metaData.alias = "g";
      "wikipedia".metaData.hidden = true;
    };
  };
}
