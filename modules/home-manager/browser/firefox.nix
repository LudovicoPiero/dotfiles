{pkgs, ...}: {
  programs.firefox = {
    enable = true;
    extensions = with pkgs.nur.repos.rycee.firefox-addons; [
      auto-tab-discard
      buster-captcha-solver
      decentraleyes
      ublock-origin
      sponsorblock
      df-youtube
      bitwarden
      fastforward
    ];
    profiles.ludovico = {
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
      settings = {
        # Country
        "browser.search.region" = "AU";
        "browser.search.isUS" = false;
        "distribution.searchplugins.defaultLocale" = "en-AU";
        "general.useragent.locale" = "en-AU";

        "browser.send_pings" = false;
        "browser.urlbar.speculativeConnect.enabled" = false;
        "dom.event.clipboardevents.enabled" = true;
        "media.navigator.enabled" = false;
        "network.cookie.cookieBehavior" = 1;
        "network.http.referer.XOriginPolicy" = 2;
        "network.http.referer.XOriginTrimmingPolicy" = 2;
        "beacon.enabled" = false;
        "browser.safebrowsing.downloads.remote.enabled" = false;
        "network.IDN_show_punycode" = true;
        "extensions.activeThemeID" = "firefox-compact-dark@mozilla.org";
        "app.shield.optoutstudies.enabled" = false;
        "dom.security.https_only_mode_ever_enabled" = true;
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        "browser.toolbars.bookmarks.visibility" = "never";
        "geo.enabled" = false;

        # Disable telemetry
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

        # Disable Pocket
        "browser.newtabpage.activity-stream.feeds.discoverystreamfeed" =
          false;
        "browser.newtabpage.activity-stream.feeds.section.topstories" = false;
        "browser.newtabpage.activity-stream.section.highlights.includePocket" =
          false;
        "browser.newtabpage.activity-stream.showSponsored" = false;
        "extensions.pocket.enabled" = false;

        # Disable prefetching
        "network.dns.disablePrefetch" = true;
        "network.prefetch-next" = false;

        # Disable JS in PDFs
        "pdfjs.enableScripting" = false;

        # Harden SSL
        "security.ssl.require_safe_negotiation" = true;

        # Extra
        "identity.fxaccounts.enabled" = false;
        "browser.search.suggest.enabled" = true;
        "browser.urlbar.shortcuts.bookmarks" = false;
        "browser.urlbar.shortcuts.history" = false;
        "browser.urlbar.shortcuts.tabs" = false;
        "browser.urlbar.suggest.bookmark" = false;
        "browser.urlbar.suggest.searches" = true;
        "browser.urlbar.suggest.engines" = false;
        "browser.urlbar.suggest.history" = true;
        "browser.urlbar.suggest.openpage" = false;
        "browser.urlbar.suggest.topsites" = false;
        "browser.uidensity" = 1;
        "media.autoplay.enabled" = false;
        "signon.rememberSignons" = false;
        "network.dns.disableIPv6" = true;
        "network.proxy.socks_remote_dns" = true;
        "permissions.delegation.enabled" = false;
        "datareporting.healthreport.uploadEnabled" = false;

        "toolkit.zoomManager.zoomValues" = ".8,.90,.95,1,1.1,1.2";

        "privacy.firstparty.isolate" = true;
        "network.http.sendRefererHeader" = 0;
      };
      userChrome = "\n                    * { \n                        box-shadow: none !important;\n                        border: 0px solid !important;\n                    }\n                    #tabbrowser-tabs {\n                        --user-tab-rounding: 8px;\n                    }\n                    .tab-background {\n                        border-radius: var(--user-tab-rounding) var(--user-tab-rounding) 0px 0px !important; /* Connected */\n                        margin-block: 1px 0 !important; /* Connected */\n                    }\n                    #scrollbutton-up, #scrollbutton-down { /* 6/10/2021 */\n                        border-top-width: 1px !important;\n                        border-bottom-width: 0 !important;\n                    }\n                    .tab-background:is([selected], [multiselected]):-moz-lwtheme {\n                        --lwt-tabs-border-color: rgba(0, 0, 0, 0.5) !important;\n                        border-bottom-color: transparent !important;\n                    }\n                    [brighttext='true'] .tab-background:is([selected], [multiselected]):-moz-lwtheme {\n                        --lwt-tabs-border-color: rgba(255, 255, 255, 0.5) !important;\n                        border-bottom-color: transparent !important;\n                    }\n                    /* Container color bar visibility */\n                    .tabbrowser-tab[usercontextid] > .tab-stack > .tab-background > .tab-context-line {\n                        margin: 0px max(calc(var(--user-tab-rounding) - 3px), 0px) !important;\n                    }\n                    #TabsToolbar, #tabbrowser-tabs {\n                        --tab-min-height: 29px !important;\n                    }\n                    #main-window[sizemode='true'] #toolbar-menubar[autohide='true'] + #TabsToolbar, \n                    #main-window[sizemode='true'] #toolbar-menubar[autohide='true'] + #TabsToolbar #tabbrowser-tabs {\n                        --tab-min-height: 30px !important;\n                    }\n                    #scrollbutton-up,\n                    #scrollbutton-down {\n                        border-top-width: 0 !important;\n                        border-bottom-width: 0 !important;\n                    }\n                    #TabsToolbar, #TabsToolbar > hbox, #TabsToolbar-customization-target, #tabbrowser-arrowscrollbox  {\n                        max-height: calc(var(--tab-min-height) + 1px) !important;\n                    }\n                    #TabsToolbar-customization-target toolbarbutton > .toolbarbutton-icon, \n                    #TabsToolbar-customization-target .toolbarbutton-text, \n                    #TabsToolbar-customization-target .toolbarbutton-badge-stack,\n                    #scrollbutton-up,#scrollbutton-down {\n                        padding-top: 7px !important;\n                        padding-bottom: 6px !important;\n                    }\n                ";
    };
  };
}
