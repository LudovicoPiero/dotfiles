{ inputs, pkgs, ... }:
{
  programs.floorp.profiles.ludovico.extensions = {
    force = true;
    packages = with inputs.firefox-addons.packages.${pkgs.stdenv.hostPlatform.system}; [
      bitwarden
      refined-github
      sponsorblock
      to-deepl
      ublock-origin
    ];
    settings = {
      "uBlock0@raymondhill.net" = {
        force = true;
        settings = {
          advancedUserEnabled = true;
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
          '';
        };
      };
    };
  };
}
