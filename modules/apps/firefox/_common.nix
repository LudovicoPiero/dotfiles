{ pkgs, inputs', ... }:
{
  bookmarks = [
    {
      name = "JP"; # Bookmark Folder
      toolbar = true;
      bookmarks = [
        {
          name = "JP Dictionary";
          keyword = "js";
          url = "https://jisho.org/";
        }
      ];
    }
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

  extensions = with inputs'.firefox-addons.packages; [
    bitwarden
    refined-github
    sponsorblock
    to-deepl
    ublock-origin
    search-by-image
    violentmonkey
    vimium-c
  ];

  extensionSettings = {
    "uBlock0@raymondhill.net" = {
      settings = {
        # Get your settings here
        # ~/.mozilla/firefox/YOUR_PROFILE_NAME/browser-extension-data/uBlock0@raymondhill.net/storage.js
        advancedUserEnabled = true;
        netWhitelist = # Trusted Sites
          ''
            localhost
            loopconversation.about-scheme
            facebook.com
          '';
        selectedFilterLists = [
          "user-filters"
          "ublock-filters"
          "ublock-badware"
          "ublock-privacy"
          "ublock-unbreak"
          "ublock-quick-fixes"
          "easylist"
          "easyprivacy"
          "urlhaus-1"
          "plowe-0"
          "adguard-spyware-url"
          "fanboy-cookiemonster"
          "ublock-cookies-easylist"
          "easylist-annoyances"
          "easylist-chat"
          "easylist-newsletters"
          "easylist-notifications"
          "ublock-annoyances"
          "IDN-0"
        ];
        "user-filters" = ''
          shopee.co.id##li.col-xs-2-4.shopee-search-item-result__item:has(div:contains(Ad))
          shopee.co.id##.oMSmr0:has(div:contains(Ad))
          tokopedia.com#?#.product-card:has(span:-abp-contains(/^Ad$/))
          tokopedia.com##a[data-testid="lnkProductContainer"]:has(img[alt^="topads"])
          tokopedia.com##div[data-ssr="findProductSSR"]:has(span[data-testid="lblTopads"])
          tokopedia.com##div[data-ssr="findProductSSR"]:has(span[data-testid="linkProductTopads"])
          tokopedia.com##div[data-testid="CPMWrapper"]
          tokopedia.com#?#div[data-testid="divCarouselProduct"]:has(span:-abp-contains(/^Ad$/))
          tokopedia.com##div[data-testid="divProduct"]:has(span[data-testid="icnHomeTopadsRecom"])
          tokopedia.com##div[data-testid="divProductWrapper"]:has(span[data-testid="divSRPTopadsIcon"])
          tokopedia.com##div[data-testid="featuredShopCntr"]
          tokopedia.com#?#div[data-testid="lazy-frame"]:has(span:-abp-contains(/^Ad$/))
          tokopedia.com##div[data-testid="lazy-frame"]:has(span[data-testid="lblProdTopads"])
          tokopedia.com##div[data-testid="master-product-card"]:has(span[data-testid^="linkProductTopads"])
          tokopedia.com##div[data-testid="topadsCPMWrapper"]
          tokopedia.com#?#div[data-testid^="divProductRecommendation"]:has(span:-abp-contains(/^Ad$/))
          tokopedia.com##div[data-testid^="divProductRecommendation"]:has(span[data-testid="icnHomeTopadsRecom"])

          ! >> uBlock filters - Annoyances should remove Suggested posts without a need for additional filters <<
          ! Suggested for you
          www.facebook.com##:is([aria-posinset],[aria-describedby]:not([aria-posinset])) div:not(:only-child)>div:only-child>div:only-child>div:first-child[class=""]>div:not([data-0]):has-text(/^Suggested/):upward([aria-posinset],[aria-describedby]:not([aria-posinset])):style(height: 0 !important; overflow: hidden !important;)
          ! Unlabelled Suggested posts (with a Follow/Join buttons)
          www.facebook.com##:is([aria-posinset],[aria-describedby]:not([aria-posinset])) :is(h3,h4) [role=button]:has-text(/Follow|Join/):upward([aria-posinset],[aria-describedby]:not([aria-posinset])):style(height: 0 !important; overflow: hidden !important;)
          ! Use only if you actually have these: Suggested posts with the label next to the post date
          www.facebook.com##:is([aria-posinset],[aria-describedby]:not([aria-posinset])):has-text(Suggested for you):style(height: 0 !important; overflow: hidden !important;)

          ! People You May Know
          www.facebook.com##:is([aria-posinset],[aria-describedby]:not([aria-posinset])):has([href="/friends/"]):style(height: 0 !important; overflow: hidden !important;)
          ! Suggested groups
          www.facebook.com##:is([aria-posinset],[aria-describedby]:not([aria-posinset])):has([href="/groups/discover/"]):style(height: 0 !important; overflow: hidden !important;)
          ! Reels and short videos (English UI)
          www.facebook.com##:is([aria-posinset],[aria-describedby]:not([aria-posinset])):has([aria-label="Reels"]):style(height: 0 !important; overflow: hidden !important;)
          ! Suggested pages
          www.facebook.com##:is([aria-posinset],[aria-describedby]:not([aria-posinset])):has([aria-label="Suggested pages"]):style(height: 0 !important; overflow: hidden !important;)

          ! Suggested for you (mobile)
          m.facebook.com##[data-mcomponent="MScreen"]>div[class="m"]>div:has-text(Suggested for you)

          ! facebook.com##[aria-label*="Marketplace"] object > a[href^="/ads/"] > span:not(:empty):upward(11)

          facebook.com##[aria-label*="Marketplace"] object:has(> a[href^="/ads/"] > span:has-text(/^Sponsored$/)):upward(a):upward(3)

          ! Removes FB's "Related discussions" panel:
          facebook.com##div[role=article] span:not(>*):has-text(/^Related discussions$/):upward(span)
          ! FB - news and group feeds - related discussions - hide the "# related" link/button
          facebook.com##div[role=button] > span:not(>*):has-text(/related/i):upward(4)

          ! Google consent, "before you continue"
          www.google.*##^script:has-text(consentCookiePayload)
          www.google.*##+js(acis, document.cookie, YES+)
          google.*##+js(aeld, DOMContentLoaded, CONSENT)
          ||consent.google.com^

          google.*##[id^="eob_"]

          ! Reddit app ad
          www.reddit.com##.XPromoPopupRpl
          www.reddit.com##xpromo-new-app-selector
          www.reddit.com##.bottom-bar, .XPromoBottomBar
          www.reddit.com##.useApp,.TopNav__promoButton
          www.reddit.com##body:style(pointer-events:auto!important;)

          ! uBO Annoyances has also this:
          ! https://github.com/uBlockOrigin/uAssets/issues/6826
          reddit.com##.XPromoPopup
          reddit.com##body.scroll-disabled:style(overflow: visible!important; position: static!important;)
          reddit.com##.XPromoInFeed
          amp.reddit.com##.AppSelectorModal__body
          amp.reddit.com##.upsell_banner

          ! 2022-11-11 20:20:47 CET:
          www.reddit.com##xpromo-app-selector
          www.reddit.com##body.scroll-is-blocked:style(overflow: visible!important; position: static!important;)
          www.reddit.com##+js(aeld, touchmove)

          ! 2022-11-12 10:11:02 CET
          www.reddit.com##.XPromoPopupRplNew

          ! 2023-09-10 14:07:31 CEST
          www.reddit.com##body[style*="pointer-events"]:style(pointer-events:auto!important;)
          www.reddit.com##body[style*="overflow"]:style(overflow:auto!important;)

          ! YT Search - keep only videos (no shorts)
          youtube.com##ytd-search ytd-item-section-renderer>#contents>:is(:not(ytd-video-renderer,yt-showing-results-for-renderer,[icon-name="promo-full-height:EMPTY_SEARCH"]),ytd-video-renderer:has([aria-label="Shorts"])),ytd-secondary-search-container-renderer

          ! YT Search - keep only videos (no shorts) and channels
          youtube.com##ytd-search ytd-item-section-renderer>#contents>:is(:not(ytd-video-renderer,ytd-channel-renderer,yt-showing-results-for-renderer,[icon-name="promo-full-height:EMPTY_SEARCH"]),ytd-video-renderer:has([aria-label="Shorts"])),ytd-secondary-search-container-renderer

          ! YT Search - keep only videos (no shorts), channels and playlists
          youtube.com##ytd-search ytd-item-section-renderer>#contents>:is(:not(ytd-video-renderer,ytd-channel-renderer,ytd-playlist-renderer,yt-lockup-view-model,yt-showing-results-for-renderer,[icon-name="promo-full-height:EMPTY_SEARCH"]),ytd-video-renderer:has([aria-label="Shorts"])),ytd-secondary-search-container-renderer

          ! Twitter/X - Get verified
          twitter.com,x.com##[aria-label="Get Verified"]
          ! Twitter/X - Live spaces
          twitter.com,x.com##[data-testid="sidebarColumn"] [data-testid="placementTracking"]:last-child:upward(1)
          ! Twitter/X - Sidebar - Topics to follow
          twitter.com,x.com##[data-testid="sidebarColumn"] [href="/i/topics/picker/home"]:upward(section)
          ! Twitter/X - Sidebar - What's happening/Trending now/Trends for you
          twitter.com,x.com##[aria-label$="trending now" i]
          ! Twitter/X - Sidebar - Who to follow/You might like
          twitter.com,x.com##[aria-label="who to follow" i]:upward(1)
          ! Twitter/X - Login Dialog
          twitter.com,x.com##div#layers div[data-testid="sheetDialog"]:upward(div[role="group"][tabindex="0"])
          twitter.com,x.com##html:style(overflow: auto !important;)
          ! Twitter/X - Switch to the app
          twitter.com,x.com###layers>div:last-of-type:has-text(Switch to the app)
        '';
      };
    };
  };

  search = {
    default = "ddg";
    order = [
      "ddg"
      "kagi"
      "brave"
      "searx"
      "google"
    ];

    engines = {
      "kagi" = {
        urls = [ { template = "https://kagi.com/search?q={searchTerms}"; } ];
        definedAliases = [ "k" ];
      };

      "google" = {
        urls = [ { template = "https://google.com/search?hl=en&pws=0&udm=14&safe=off&brd_browser=chrome&q={searchTerms}"; } ];
        definedAliases = [ "g" ];
      };

      "jisho" = {
        urls = [ { template = "https://jisho.org/search/{searchTerms}"; } ];
        definedAliases = [ "j" ];
      };

      "searx" = {
        urls = [
          {
            template = "https://opnxng.com/search";
            params = [
              {
                name = "q";
                value = "{searchTerms}";
              }
              {
                name = "categories";
                value = "general";
              }
              {
                name = "language";
                value = "all";
              }
              {
                name = "safesearch";
                value = "0";
              }
            ];
          }
        ];
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

      "github (code)" = {
        urls = [
          { template = "https://github.com/search?q={searchTerms}&type=code"; }
        ];
        definedAliases = [ "ghc" ];
      };

      "github (repository)" = {
        urls = [
          { template = "https://github.com/search?q={searchTerms}&type=repository"; }
        ];
        definedAliases = [ "ghr" ];
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
        urls = [
          { template = "https://wiki.nixos.org/w/index.php?search={searchTerms}"; }
        ];
        icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
        definedAliases = [ "nw" ];
      };

      "youtube" = {
        urls = [
          { template = "https://www.youtube.com/results?search_query={searchTerms}"; }
        ];
        definedAliases = [ "yt" ];
      };

      "amazondotcom-us".metaData.hidden = true;
      "bing".metaData.hidden = true;
      "ebay".metaData.hidden = true;
      "wikipedia".metaData.hidden = true;
    };
  };
}
