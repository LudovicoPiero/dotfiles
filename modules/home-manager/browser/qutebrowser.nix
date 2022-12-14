{
  config,
  lib,
  pkgs,
  ...
}: {
  programs.qutebrowser = {
    enable = true;
    package = pkgs.qutebrowser-qt6;
    searchEngines = {
      w = "https://en.wikipedia.org/wiki/Special:Search?search={}&go=Go&ns0=1";
      aw = "https://wiki.archlinux.org/?search={}";
      nw = "https://nixos.wiki/index.php?search={}";
      np = "https://search.nixos.org/packages?channel=unstable&type=packages&query={}";
      no = "https://search.nixos.org/options?channel=unstable&type=packages&query={}";
      g = "https://www.google.com/search?hl=en&q={}";
    };
    settings = {
      qt.args = [
        "enable-accelerated-video-decode"
        "enable-native-gpu-memory-buffers"
        "enable-gpu-rasterization"
        "use-egl=desktop"
        "ignore-gpu-blocklist"
      ];
      scrolling.smooth = true;
    };
  };
}
