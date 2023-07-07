let
  ungoogledFlags = [
    "--disable-search-engine-collection"
    "--extension-mime-request-handling=always-prompt-for-install"
    "--fingerprinting-canvas-image-data-noise"
    "--fingerprinting-canvas-measuretext-noise"
    "--fingerprinting-client-rects-noise"
    "--popups-to-tabs"
    "--show-avatar-button=incognito-and-guest"
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
  ];

  performanceFlags = [
    "--enable-gpu-rasterization"
    "--enable-oop-rasterization"
    "--enable-zero-copy"
    "--ignore-gpu-blocklist"
  ];

  waylandFlags = [
    # "--use-gl=egl"
    "--ozone-platform=wayland"
    "--enable-features=UseOzonePlatform"
  ];
in
  final: prev: {
    ungoogled-chromium = prev.ungoogled-chromium.override {
      nss = final.nss_latest;
      commandLineArgs = toString (
        ungoogledFlags
        ++ ["--enable-features=${final.lib.concatStringsSep "," experimentalFeatures}"]
        ++ aestheticsFlags
        ++ performanceFlags
        ++ waylandFlags
      );
    };

    google-chrome-dev = prev.google-chrome-dev.override {
      nss = final.nss_latest;
      commandLineArgs = toString (
        ungoogledFlags
        ++ ["--enable-features=${final.lib.concatStringsSep "," experimentalFeatures}"]
        ++ aestheticsFlags
        ++ performanceFlags
        ++ waylandFlags
      );
    };
  }
