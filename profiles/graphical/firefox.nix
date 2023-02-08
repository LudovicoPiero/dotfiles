{
  pkgs,
  config,
  ...
}: {
  home-manager.users."${config.vars.username}".programs.firefox = {
    enable = true;
    profiles.ludovico = {
      id = 0;
      isDefault = true;
      name = "Ludovico";
      extensions = with config.nur.repos.rycee.firefox-addons; [
        ublock-origin
        bitwarden
        fastforward
      ];
      bookmarks = [
        {
          name = "ANIME"; # Bookmark Folder
          bookmarks = [
            {
              name = "ANIMEPAHE";
              url = "https://animepahe.com";
            }
            {
              name = "KICKASSANIME";
              url = "https://kickassanime.ro";
            }
            {
              name = "9Anime";
              url = "https://9anime.gs";
            }
          ];
        }
        {
          name = "NixOS";
          bookmarks = [
            {
              name = "Nix Package";
              url = "https://search.nixos.org/packages?channel=unstable";
            }
            {
              name = "Nix Options";
              url = "https://search.nixos.org/options?channel=unstable";
            }
            {
              name = "Home-Manager";
              url = "https://rycee.gitlab.io/home-manager/options.html";
            }
          ];
        }
      ];
      search = {
        default = "DuckDuckGo";
        force = true;
        engines = {
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
            definedAliases = ["@np"];
          };
          "Home-Manager" = {
            urls = [
              {
                template = "https://rycee.gitlab.io/home-manager/options.html";
              }
            ];
            definedAliases = ["@hm"];
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
            definedAliases = ["@no"];
          };

          "NixOS Wiki" = {
            urls = [
              {
                template = "https://nixos.wiki/index.php?search={searchTerms}";
              }
            ];
            icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
            definedAliases = ["@nw"];
          };
        };
      };
      settings = {
        "browser.search.region" = "AU";
        "browser.search.isUS" = false;
        "distribution.searchplugins.defaultLocale" = "en-AU";
        "general.useragent.locale" = "en-AU";
        "browser.bookmarks.showMobileBookmarks" = true;
        "general.smoothScroll" = true;
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;

        # # Disable telemetry
        "browser.newtabpage.activity-stream.feeds.telemetry" = false;
        "browser.ping-centre.telemetry" = false;
        "browser.tabs.crashReporting.sendReport" = false;
        "devtools.onboarding.telemetry.logged" = false;
        "toolkit.telemetry.enabled" = false;
        "toolkit.telemetry.server" = "data:,";
        "toolkit.telemetry.unified" = false;
        "toolkit.telemetry.archive.enabled" = false;
        "toolkit.telemetry.newProfilePing.enabled" = false;
        "toolkit.telemetry.shutdownPingSender.enabled" = false;
        "toolkit.telemetry.updatePing.enabled" = false;
        "toolkit.telemetry.bhrPing.enabled" = false;
        "toolkit.telemetry.firstShutdownPing.enabled" = false;

        # # Disable Pocket
        "browser.newtabpage.activity-stream.feeds.discoverystreamfeed" = false;
        "browser.newtabpage.activity-stream.feeds.section.topstories" = false;
        "browser.newtabpage.activity-stream.section.highlights.includePocket" = false;
        "browser.newtabpage.activity-stream.showSponsored" = false;
        "extensions.pocket.enabled" = false;

        # Disable prefetching
        "network.dns.disablePrefetch" = true;
        "network.prefetch-next" = false;

        # Disable JS in PDFs
        "pdfjs.enableScripting" = false;

        # Harden SSL
        "security.ssl.require_safe_negotiation" = true;

        # # Extra
        "identity.fxaccounts.enabled" = false;
        "browser.search.suggest.enabled" = false;
        "browser.urlbar.suggest.searches" = false;
        "browser.urlbar.shortcuts.bookmarks" = false;
        "browser.urlbar.shortcuts.history" = false;
        "browser.urlbar.shortcuts.tabs" = false;
        "browser.urlbar.suggest.bookmark" = false;
        "browser.urlbar.suggest.searches" = true;
        "browser.urlbar.suggest.engines" = false;
        "browser.urlbar.suggest.history" = true;
        "browser.urlbar.suggest.openpage" = false;
        "browser.urlbar.suggest.topsites" = false;
        "signon.rememberSignons" = false;
        "network.dns.disableIPv6" = true;
        "network.proxy.socks_remote_dns" = true;
        "dom.security.https_first" = true;
      };
      userChrome = ''
              * {
          box-shadow: none !important;
          border: 0px solid !important;
        }
        #tabbrowser-tabs {
          --user-tab-rounding: 8px;
        }
        .tab-background {
          border-radius: var(--user-tab-rounding) var(--user-tab-rounding) 0px 0px !important; /* Connected */
          margin-block: 1px 0 !important; /* Connected */
        }
        #scrollbutton-up,
        #scrollbutton-down {
          /* 6/10/2021 */
          border-top-width: 1px !important;
          border-bottom-width: 0 !important;
        }
        .tab-background:is([selected], [multiselected]):-moz-lwtheme {
          --lwt-tabs-border-color: rgba(0, 0, 0, 0.5) !important;
          border-bottom-color: transparent !important;
        }
        [brighttext="true"]
          .tab-background:is([selected], [multiselected]):-moz-lwtheme {
          --lwt-tabs-border-color: rgba(255, 255, 255, 0.5) !important;
          border-bottom-color: transparent !important;
        } /* Container color bar visibility */
        .tabbrowser-tab[usercontextid]
          > .tab-stack
          > .tab-background
          > .tab-context-line {
          margin: 0px max(calc(var(--user-tab-rounding) - 3px), 0px) !important;
        }
        #TabsToolbar,
        #tabbrowser-tabs {
          --tab-min-height: 29px !important;
        }
        #main-window[sizemode="true"] #toolbar-menubar[autohide="true"] + #TabsToolbar,
        #main-window[sizemode="true"]
          #toolbar-menubar[autohide="true"]
          + #TabsToolbar
          #tabbrowser-tabs {
          --tab-min-height: 30px !important;
        }
        #scrollbutton-up,
        #scrollbutton-down {
          border-top-width: 0 !important;
          border-bottom-width: 0 !important;
        }
        #TabsToolbar,
        #TabsToolbar > hbox,
        #TabsToolbar-customization-target,
        #tabbrowser-arrowscrollbox {
          max-height: calc(var(--tab-min-height) + 1px) !important;
        }
        #TabsToolbar-customization-target toolbarbutton > .toolbarbutton-icon,
        #TabsToolbar-customization-target .toolbarbutton-text,
        #TabsToolbar-customization-target .toolbarbutton-badge-stack,
        #scrollbutton-up,
        #scrollbutton-down {
          padding-top: 7px !important;
          padding-bottom: 6px !important;
        }
      '';
    };
  };
}
