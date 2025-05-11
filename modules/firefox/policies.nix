{ config, lib, ... }:
let
  cfg = config.myOptions.firefox;
  inherit (lib) mkIf;
in
{
  config = mkIf cfg.enable {
    programs.firefox.policies = {
      AppAutoUpdate = false;
      FirefoxSuggest = {
        "SponsoredSuggestions" = false;
      };
      DisableTelemetry = true;
      HardwareAcceleration = true;
      PasswordManagerEnabled = false;
      OfferToSaveLogins = false;
      OfferToSaveLoginsDefault = false;
      SSLVersionMin = "tls1.2";
      # REF https://mozilla.github.io/policy-templates/#extensions
      # NOTE find UUID for each extension in about:debugging#/runtime/this-firefox
      Extensions = {
        Locked = [
          "uBlock0@raymondhill.net"
          "{446900e4-71c2-419f-a6a7-df9c091e268b}" # bitwarden
          "{a4c4eda4-fb84-4a84-b4a1-f7c1cbf2a1ad}" # refined github
          "{2e5ff8c8-32fe-46d0-9fc8-6b8986621f3c}" # search by image
          "sponsorBlocker@ajay.app"
          "{db420ff1-427a-4cda-b5e7-7d395b9f16e1}" # toDeepL
        ];
      };
      ExtensionSettings = {
        "uBlock0@raymondhill.net" = {
          default_area = "navbar";
          "installation_mode" = "force_installed";
          "install_url" = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi"; # using slug / short name
        };
        "sponsorBlocker@ajay.app" = {
          default_area = "navbar";
          "installation_mode" = "force_installed";
          "install_url" = "https://addons.mozilla.org/firefox/downloads/latest/sponsorblock/latest.xpi";
        };
        "{446900e4-71c2-419f-a6a7-df9c091e268b}" = {
          default_area = "navbar";
          "installation_mode" = "force_installed";
          "install_url" =
            "https://addons.mozilla.org/firefox/downloads/latest/bitwarden-password-manager/latest.xpi";
        };
        "{a4c4eda4-fb84-4a84-b4a1-f7c1cbf2a1ad}" = {
          "installation_mode" = "force_installed";
          "install_url" = "https://addons.mozilla.org/firefox/downloads/latest/refined-github-/latest.xpi";
        };
        "{2e5ff8c8-32fe-46d0-9fc8-6b8986621f3c}" = {
          "installation_mode" = "force_installed";
          "install_url" = "https://addons.mozilla.org/firefox/downloads/latest/search_by_image/latest.xpi";
        };
        "{db420ff1-427a-4cda-b5e7-7d395b9f16e1}" = {
          "installation_mode" = "force_installed";
          "install_url" = "https://addons.mozilla.org/firefox/downloads/latest/to-deepl/latest.xpi";
        };
      };

      # Search Engines
      SearchEngines = {
        Default = "DuckDuckGo";
        SearchSuggestEnabled = false;
        Remove = [
          "Bing"
          "Amazon.com"
          "eBay"
          "Wikipedia"
        ];
        PreventInstalls = false;
        Add = [
          {
            Name = "SearX";
            URLTemplate = "https://opnxng.com/search?q={searchTerms}language=all&time_range=&safesearch=0&categories=general";
            Alias = "s";
          }
          {
            Name = "DuckDuckGo";
            URLTemplate = "https://duckduckgo.com/?q={searchTerms}";
            Alias = "ddg";
          }
          {
            Name = "Google";
            URLTemplate = "https://google.com/?q={searchTerms}";
            Alias = "g";
          }
          {
            Name = "Nix Options";
            URLTemplate = "https://search.nixos.org/options?channel=unstable&query={searchTerms}";
            Alias = "no";
          }
          {
            Name = "Nix Packages";
            URLTemplate = "https://search.nixos.org/packages?channel=unstable&query={searchTerms}";
            Alias = "np";
          }
          {
            Name = "Github (Code)";
            URLTemplate = "https://github.com/search?q={searchTerms}&type=code";
            Alias = "ghc";
          }
          {
            Name = "Github (Repository)";
            URLTemplate = "https://github.com/search?q={searchTerms}&type=repositories";
            Alias = "ghr";
          }
        ];
      };

      # Bookmarks
      ManagedBookmarks = [
        { toplevel_name = "Links"; }
        {
          name = "Nix";
          children = [
            {
              name = "nixos-forum";
              url = "https://discourse.nixos.org/latest";
            }
          ];
        }
        {
          name = "ANIME";
          children = [
            {
              name = "Animekaito";
              url = "https://animekai.to/home";
            }
            {
              name = "KICKASSANIME";
              url = "https://kaa.mx";
            }
          ];
        }
        {
          name = "1337";
          children = [
            {
              name = "GitHub";
              url = "https://github.com";
            }
            {
              name = "GitLab";
              url = "https://gitlab.com";
            }
            {
              name = "SourceHut";
              url = "https://git.sr.ht";
            }
          ];
        }
      ];
    };
  };
}
