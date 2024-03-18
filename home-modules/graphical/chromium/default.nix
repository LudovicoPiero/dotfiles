{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.mine.chromium;
  inherit (lib) mkEnableOption mkIf;

  ungoogledFlags = [
    "--disable-search-engine-collection"
    "--extension-mime-request-handling=always-prompt-for-install"
    "--fingerprinting-canvas-image-data-noise"
    "--fingerprinting-canvas-measuretext-noise"
    "--fingerprinting-client-rects-noise"
    "--popups-to-tabs"
    "--show-avatar-button=incognito-and-guest"
    "--extension-mime-request-handling=always-prompt-for-install"
  ];

  experimentalFeatures = [
    "BackForwardCache:enable_same_site/true"
    "CopyLinkToText"
    "OverlayScrollbar"
    "TabHoverCardImages"
    "VaapiVideoDecoder"
  ];

  aestheticsFlags = [
    "--force-dark-mode"
    "--hide-sidepanel-button"
  ];

  performanceFlags = [
    "--enable-gpu-rasterization"
    "--enable-oop-rasterization"
    "--enable-zero-copy"
    "--ignore-gpu-blocklist"
  ];

  waylandFlags = [
    "--ozone-platform=wayland"
    "--enable-features=UseOzonePlatform"
  ];
in {
  options.mine.chromium.enable = mkEnableOption "chromium";

  config = mkIf cfg.enable {
    programs.chromium = {
      enable = true;
      package = pkgs.ungoogled-chromium;

      commandLineArgs =
        ungoogledFlags
        ++ ["--enable-features=${lib.concatStringsSep "," experimentalFeatures}"]
        ++ aestheticsFlags
        ++ waylandFlags
        ++ performanceFlags;

      # extensions = []; # Doesn't work with ungoogled-chromium
    };
  };
}
