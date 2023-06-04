{
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

  # Firefox GNOME Theme
  # Hide the tab bar when only one tab is open.
  "gnomeTheme.hideSingleTab" = false;
  # Move Bookmarks toolbar under tabs.
  "gnomeTheme.bookmarksToolbarUnderTabs" = true;
  # Hide WebRTC indicator since GNOME provides their own privacy icons in the top right.
  "gnomeTheme.hideWebrtcIndicator" = true;
  # Use system theme icons instead of Adwaita icons included by theme.
  "gnomeTheme.systemIcons" = true;
}
