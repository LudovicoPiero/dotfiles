{
  inputs,
  lib,
  config,
  ...
}:
{
  mine.programs.zen-browser.profiles.ludovico.settings =
    {
      # Homepage
      "browser.startup.page" = 1;
      "browser.startup.homepage" = "${inputs.self}/assets/homepage.html";

      # Zen Settings
      "zen.tab-unloader.enabled" = true;
      "zen.tab-unloader.timeout-minutes" = 20;
      "zen.view.sidebar-expanded" = false;
      "zen.view.show-newtab-button-top" = false;
      "zen.welcome-screen.seen" = true;

      "media.videocontrols.picture-in-picture.video-toggle.enabled" = false; # Hide picture-in-picture
      "extensions.autoDisableScopes" = 0;
      "browser.search.region" = "AU";
      "browser.search.isUS" = false;
      "distribution.searchplugins.defaultLocale" = "en-AU";
      "general.useragent.locale" = "en-AU";
      "browser.bookmarks.showMobileBookmarks" = true;
      "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
      "browser.privatebrowsing.vpnpromourl" = "";
      "browser.tabs.firefox-view" = false; # Disable Firefox View
      "browser.tabs.firefox-view-next" = false;
      "browser.shell.checkDefaultBrowser" = false;
      "browser.ctrlTab.sortByRecentlyUsed" = true;

      "network.trr.mode" = 2;
      "network.trr.max-fails" = 5;
      "network.trr.default_provider_uri" = "https://dns.nextdns.io/518d18/nixos";
      "network.trr.uri" = "https://dns.nextdns.io/518d18/nixos";
      "network.trr.custom_uri" = "https://dns.nextdns.io/518d18/nixos";
      "network.trr.bootstrapAddress" = "1.1.1.1";

      # Disable telemetry
      "datareporting.usage.uploadEnabled" = false;
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

      # Tweaks from archwiki
      "browser.cache.disk.enable" = false;
      "browser.cache.memory.enable" = true;
      "browser.cache.memory.capacity" = 131072; # 128 MB
      "browser.cache.memory.max_entry_size" = 20480; # 20 MB
      "browser.aboutConfig.showWarning" = false;
      "browser.preferences.defaultPerformanceSettings.enabled" = false;
      "browser.places.speculativeConnect.enabled" = false;
      "middlemouse.paste" = false;

      # Smooth Scroll
      # "general.smoothScroll" = true;
      # "general.smoothScroll.lines.durationMaxMS" = 125;
      # "general.smoothScroll.lines.durationMinMS" = 125;
      # "general.smoothScroll.mouseWheel.durationMaxMS" = 200;
      # "general.smoothScroll.mouseWheel.durationMinMS" = 100;
      # "general.smoothScroll.msdPhysics.enabled" = true;
      # "general.smoothScroll.other.durationMaxMS" = 125;
      # "general.smoothScroll.other.durationMinMS" = 125;
      # "general.smoothScroll.pages.durationMaxMS" = 125;
      # "general.smoothScroll.pages.durationMinMS" = 125;
      # "mousewheel.min_line_scroll_amount" = 30;
      # "mousewheel.system_scroll_override_on_root_content.enabled" = true;
      # "mousewheel.system_scroll_override_on_root_content.horizontal.factor" = 175;
      # "mousewheel.system_scroll_override_on_root_content.vertical.factor" = 175;
      # "toolkit.scrollbox.horizontalScrollDistance" = 6;
      # "toolkit.scrollbox.verticalScrollDistance" = 2;

      # Extra
      "identity.fxaccounts.enabled" = false;
      "browser.download.useDownloadDir" = false;
      "browser.search.suggest.enabled" = false;
      "browser.urlbar.shortcuts.bookmarks" = false;
      "browser.urlbar.shortcuts.history" = false;
      "browser.urlbar.shortcuts.tabs" = false;
      "browser.urlbar.suggest.bookmark" = false;
      "browser.urlbar.suggest.searches" = false;
      "browser.urlbar.suggest.engines" = false;
      "browser.urlbar.suggest.history" = true;
      "browser.urlbar.suggest.openpage" = false;
      "browser.urlbar.suggest.topsites" = false;
      "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.addons" = false;
      "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.features" = false;
      "signon.rememberSignons" = false;
      "signon.autofillForms" = false;
      "network.dns.disableIPv6" = true;
      "network.proxy.socks_remote_dns" = true;
      "dom.security.https_first" = true;

      # Disable permission
      # 0=always ask (default), 1=allow, 2=block
      "permissions.default.geo" = 2;
      "permissions.default.camera" = 2;
      "permissions.default.microphone" = 0;
      "permissions.default.desktop-notification" = 2;
      "permissions.default.xr" = 2; # Virtual Reality
      "browser.discovery.enabled" = false;
      "datareporting.healthreport.uploadEnabled" = false;
      "datareporting.policy.dataSubmissionEnabled" = false;
      "app.shield.optoutstudies.enabled" = false;
      "app.normandy.enabled" = false;
      "app.normandy.api_url" = "";

      # Firefox GNOME Theme
      # Hide the tab bar when only one tab is open.
      "gnomeTheme.hideSingleTab" = false;
      # By default the tab close buttons follows the position of the window controls, this preference reverts that behavior.
      "gnomeTheme.swapTabClose" = true;
      # Move Bookmarks toolbar under tabs.
      "gnomeTheme.bookmarksToolbarUnderTabs" = true;
      # Hide WebRTC indicator since GNOME provides their own privacy icons in the top right.
      "gnomeTheme.hideWebrtcIndicator" = true;
      # Use system theme icons instead of Adwaita icons included by theme.
      "gnomeTheme.systemIcons" = true;
    }
    // lib.optionalAttrs config.mine.dnscrypt2.enable {
      # DOH
      /*
        2 is enable DOH.
        3 is no failback to system dns
        5 is no DOH.
      */
      "network.trr.mode" = 5;
      "network.trr.max-fails" = 5;
      "network.trr.default_provider_uri" = "";
      "network.trr.uri" = "";
      "network.trr.custom_uri" = "";
      # "network.trr.bootstrapAddress" = "1.1.1.1";
    };
}
