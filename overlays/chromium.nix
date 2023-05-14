final: prev: {
  ungoogled-chromium = prev.ungoogled-chromium.override {
    extensions = [
      {id = "cjpalhdlnbpafiamejdnhcphjbkeiagm";} # uBlock Origin
      {id = "nngceckbapebfimnlniiiahkandclblb";} # Bitwarden
      {id = "eimadpbcbfnmbkopoojfekhnkhdbieeh";} # Dark Reader
      {id = "ldpochfccmkkmhdbclfhpagapcfdljkj";} # Decentraleyes
      {
        id = "ilcacnomdmddpohoakmgcboiehclpkmj";
        updateUrl = "https://raw.githubusercontent.com/FastForwardTeam/releases/main/update/update.xml";
      }
    ];

    commandLineArgs = toString [
      # Ungoogled features
      "--disable-search-engine-collection"
      "--extension-mime-request-handling=always-prompt-for-install"
      "--fingerprinting-canvas-image-data-noise"
      "--fingerprinting-canvas-measuretext-noise"
      "--fingerprinting-client-rects-noise"
      "--popups-to-tabs"
      "--show-avatar-button=incognito-and-guest"

      # Experimental features
      "--enable-features=${
        final.lib.concatStringsSep "," [
          "BackForwardCache:enable_same_site/true"
          "CopyLinkToText"
          "TabHoverCardImages"
          "VaapiVideoDecoder"
        ]
      }"

      # Aesthetics
      "--force-dark-mode"

      # Performance
      "--enable-gpu-rasterization"
      "--enable-oop-rasterization"
      "--enable-zero-copy"
      "--ignore-gpu-blocklist"

      # Wayland
      "--enable-features=UseOzonePlatform"
      "--ozone-platform=wayland"

      # Etc
      "--disk-cache=$XDG_RUNTIME_DIR/chromium-cache"
      "--no-default-browser-check"
      "--no-service-autorun"
      "--disable-features=PreloadMediaEngagementData,MediaEngagementBypassAutoplayPolicies"
      "--disable-reading-from-canvas"
      "--no-pings"
      "--no-first-run"
      "--no-experiments"
      "--no-crash-upload"
      "--disable-wake-on-wifi"
      "--disable-breakpad"
      "--disable-sync"
      "--disable-speech-api"
      "--disable-speech-synthesis-api"
    ];
  };
  chromium = prev.chromium.override {
    extensions = [
      {id = "cjpalhdlnbpafiamejdnhcphjbkeiagm";} # uBlock Origin
      {id = "nngceckbapebfimnlniiiahkandclblb";} # Bitwarden
      {id = "eimadpbcbfnmbkopoojfekhnkhdbieeh";} # Dark Reader
      {id = "ldpochfccmkkmhdbclfhpagapcfdljkj";} # Decentraleyes
      {
        id = "ilcacnomdmddpohoakmgcboiehclpkmj";
        updateUrl = "https://raw.githubusercontent.com/FastForwardTeam/releases/main/update/update.xml";
      }
    ];

    commandLineArgs = toString [
      # Ungoogled features
      "--disable-search-engine-collection"
      "--extension-mime-request-handling=always-prompt-for-install"
      "--fingerprinting-canvas-image-data-noise"
      "--fingerprinting-canvas-measuretext-noise"
      "--fingerprinting-client-rects-noise"
      "--popups-to-tabs"
      "--show-avatar-button=incognito-and-guest"

      # Experimental features
      "--enable-features=${
        final.lib.concatStringsSep "," [
          "BackForwardCache:enable_same_site/true"
          "CopyLinkToText"
          "TabHoverCardImages"
          "VaapiVideoDecoder"
        ]
      }"

      # Aesthetics
      "--force-dark-mode"

      # Performance
      "--enable-gpu-rasterization"
      "--enable-oop-rasterization"
      "--enable-zero-copy"
      "--ignore-gpu-blocklist"

      # Wayland
      "--enable-features=UseOzonePlatform"
      "--ozone-platform=wayland"

      # Etc
      "--disk-cache=$XDG_RUNTIME_DIR/chromium-cache"
      "--no-default-browser-check"
      "--no-service-autorun"
      "--disable-features=PreloadMediaEngagementData,MediaEngagementBypassAutoplayPolicies"
      "--disable-reading-from-canvas"
      "--no-pings"
      "--no-first-run"
      "--no-experiments"
      "--no-crash-upload"
      "--disable-wake-on-wifi"
      "--disable-breakpad"
      "--disable-sync"
      "--disable-speech-api"
      "--disable-speech-synthesis-api"
    ];
  };
}
