{ pkgs, ... }:
{
  default = "Brave";
  force = true;
  engines = {
    "Brave" = {
      urls = [ { template = "https://search.brave.com/search?q={searchTerms}"; } ];
      definedAliases = [ "b" ];
      icon = "${pkgs.brave}/share/icons/hicolor/64x64/apps/brave-browser.png";
    };

    "DuckDuckGo" = {
      urls = [ { template = "https://duckduckgo.com/?q={searchTerms}"; } ];
      definedAliases = [ "d" ];
    };

    "GitHub" = {
      urls = [ { template = "https://github.com/search?q={searchTerms}&type=code"; } ];
      definedAliases = [ "gh" ];
    };

    "Nix Packages" = {
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

    "Home-Manager" = {
      urls = [ { template = "https://rycee.gitlab.io/home-manager/options.html"; } ];
      definedAliases = [ "hm" ];
    };

    "NixOS Options" = {
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

    "NixOS Wiki" = {
      urls = [ { template = "https://wiki.nixos.org/wiki/{searchTerms}"; } ];
      icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
      definedAliases = [ "nw" ];
    };

    "YouTube" = {
      urls = [ { template = "https://www.youtube.com/results?search_query={searchTerms}"; } ];
      definedAliases = [ "yt" ];
    };

    "Bing".metaData.hidden = true;
    "Google".metaData.alias = "g";
  };
}
