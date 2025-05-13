{
  inputs,
  lib,
  config,
  ...
}:
let
  cfg = config.myOptions.firefox;
in
{
  config = lib.mkIf cfg.enable {
    hj.files.".mozilla/firefox/${config.vars.username}/user.js".text = ''
      // My Custom Firefox Preferences
      // Homepage

      user_pref("browser.startup.page", 1);
      user_pref("browser.startup.homepage", "${inputs.self}/assets/homepage.html");

      user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);
      user_pref("svg.context-properties.content.enabled", true);
      user_pref("browser.uidensity", 0);
      user_pref("browser.theme.dark-private-windows", false);
      user_pref("widget.gtk.rounded-bottom-corners.enabled", true);

      user_pref("extensions.autoDisableScopes", 0);
      user_pref("browser.search.region", "AU");
      user_pref("browser.search.isUS", false);
      user_pref("distribution.searchplugins.defaultLocale", "en-AU");
      user_pref("general.useragent.locale", "en-AU");
      user_pref("browser.bookmarks.showMobileBookmarks", true);
      user_pref("browser.privatebrowsing.vpnpromourl", "");
      user_pref("browser.tabs.firefox-view", false); // Disable Firefox View
      user_pref("browser.tabs.firefox-view-next", false);

      user_pref("sidebar.verticalTabs", false);
      user_pref("sidebar.main.tools", "");
      user_pref("sidebar.visibility", "hide-sidebar");
      user_pref("sidebar.revamp", false);
      user_pref("browser.ml.chat.enabled", false);
      user_pref("gfx.webrender.all", true);

      user_pref("network.trr.mode", 2);
      user_pref("network.trr.max-fails", 5);
      user_pref("network.trr.default_provider_uri", "https://dns.nextdns.io/518d18/nixos");
      user_pref("network.trr.uri", "https://dns.nextdns.io/518d18/nixos");
      user_pref("network.trr.custom_uri", "https://dns.nextdns.io/518d18/nixos");
      user_pref("network.trr.bootstrapAddress", "1.1.1.1");

      // Disable telemetry
      user_pref("browser.newtabpage.activity-stream.feeds.telemetry", false);
      user_pref("browser.ping-centre.telemetry", false);
      user_pref("browser.tabs.crashReporting.sendReport", false);
      user_pref("devtools.onboarding.telemetry.logged", false);
      user_pref("toolkit.telemetry.enabled", false);
      user_pref("toolkit.telemetry.server", "data:,");
      user_pref("toolkit.telemetry.unified", false);
      user_pref("toolkit.telemetry.archive.enabled", false);
      user_pref("toolkit.telemetry.newProfilePing.enabled", false);
      user_pref("toolkit.telemetry.shutdownPingSender.enabled", false);
      user_pref("toolkit.telemetry.updatePing.enabled", false);
      user_pref("toolkit.telemetry.bhrPing.enabled", false);
      user_pref("toolkit.telemetry.firstShutdownPing.enabled", false);

      // Disable Pocket
      user_pref("browser.newtabpage.activity-stream.feeds.discoverystreamfeed", false);
      user_pref("browser.newtabpage.activity-stream.feeds.section.topstories", false);
      user_pref("browser.newtabpage.activity-stream.section.highlights.includePocket", false);
      user_pref("browser.newtabpage.activity-stream.showSponsored", false);
      user_pref("extensions.pocket.enabled", false);

      // Disable prefetching
      user_pref("network.dns.disablePrefetch", true);
      user_pref("network.prefetch-next", false);

      // Disable JS in PDFs
      user_pref("pdfjs.enableScripting", false);

      // Harden SSL
      user_pref("security.ssl.require_safe_negotiation", true);

      // Tweaks from archwiki
      user_pref("browser.cache.disk.enable", false);
      user_pref("browser.cache.memory.enable", true);
      user_pref("browser.cache.memory.capacity", -1);
      user_pref("browser.aboutConfig.showWarning", false);
      user_pref("browser.preferences.defaultPerformanceSettings.enabled", false);
      user_pref("middlemouse.paste", false);

      // Smooth Scroll
      user_pref("general.smoothScroll", true);
      user_pref("general.smoothScroll.lines.durationMaxMS", 125);
      user_pref("general.smoothScroll.lines.durationMinMS", 125);
      user_pref("general.smoothScroll.mouseWheel.durationMaxMS", 200);
      user_pref("general.smoothScroll.mouseWheel.durationMinMS", 100);
      user_pref("general.smoothScroll.msdPhysics.enabled", true);
      user_pref("general.smoothScroll.other.durationMaxMS", 125);
      user_pref("general.smoothScroll.other.durationMinMS", 125);
      user_pref("general.smoothScroll.pages.durationMaxMS", 125);
      user_pref("general.smoothScroll.pages.durationMinMS", 125);
      user_pref("mousewheel.min_line_scroll_amount", 30);
      user_pref("mousewheel.system_scroll_override_on_root_content.enabled", true);
      user_pref("mousewheel.system_scroll_override_on_root_content.horizontal.factor", 175);
      user_pref("mousewheel.system_scroll_override_on_root_content.vertical.factor", 175);
      user_pref("toolkit.scrollbox.horizontalScrollDistance", 6);
      user_pref("toolkit.scrollbox.verticalScrollDistance", 2);

      // Extra
      user_pref("identity.fxaccounts.enabled", false);
      user_pref("browser.download.useDownloadDir", false);
      user_pref("browser.search.suggest.enabled", false);
      user_pref("browser.urlbar.shortcuts.bookmarks", false);
      user_pref("browser.urlbar.shortcuts.history", false);
      user_pref("browser.urlbar.shortcuts.tabs", false);
      user_pref("browser.urlbar.suggest.bookmark", true);
      user_pref("browser.urlbar.suggest.searches", false);
      user_pref("browser.urlbar.suggest.engines", true);
      user_pref("browser.urlbar.suggest.history", true);
      user_pref("browser.urlbar.suggest.openpage", false);
      user_pref("browser.urlbar.suggest.topsites", false);
      user_pref("browser.newtabpage.activity-stream.asrouter.userprefs.cfr.addons", false);
      user_pref("browser.newtabpage.activity-stream.asrouter.userprefs.cfr.features", false);
      user_pref("signon.rememberSignons", false);
      user_pref("signon.autofillForms", false);
      user_pref("network.dns.disableIPv6", true);
      user_pref("network.proxy.socks_remote_dns", true);
      user_pref("dom.security.https_first", true);

      // Disable permission prompts
      user_pref("permissions.default.geo", 2);
      user_pref("permissions.default.camera", 2);
      user_pref("permissions.default.microphone", 0);
      user_pref("permissions.default.desktop-notification", 2);
      user_pref("permissions.default.xr", 2); // Virtual Reality
      user_pref("browser.discovery.enabled", false);
      user_pref("datareporting.healthreport.uploadEnabled", false);
      user_pref("datareporting.policy.dataSubmissionEnabled", false);
      user_pref("app.shield.optoutstudies.enabled", false);
      user_pref("app.normandy.enabled", false);
      user_pref("app.normandy.api_url", "");

      // Firefox GNOME Theme
      user_pref("gnomeTheme.hideSingleTab", false);
      user_pref("gnomeTheme.swapTabClose", true);
      user_pref("gnomeTheme.bookmarksToolbarUnderTabs", true);
      user_pref("gnomeTheme.hideWebrtcIndicator", true);
      user_pref("gnomeTheme.systemIcons", true);
    '';
  };
}
