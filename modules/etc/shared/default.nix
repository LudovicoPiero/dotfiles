{
  lib,
  inputs,
  inputs',
  self',
  pkgs,
  config,
  ...
}:
{
  # NixOS Stuff
  imports = [ inputs.lix-module.nixosModules.default ];

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowUnfreePredicate = _: true;
  hardware.enableRedistributableFirmware = lib.mkDefault true;
  hardware.enableAllFirmware = true;
  time.timeZone = config.vars.timezone;

  programs = {
    dconf.enable = true;
    nh = {
      enable = true;
      flake = "${config.vars.homeDirectory}/Code/nixos";
      clean = {
        enable = true;
        dates = "weekly";
        extraArgs = "--keep 3";
      };
    };
  };

  environment = {
    sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
      FZF_DEFAULT_COMMAND = "rg --files --hidden --follow --glob '!.git/*'";
      FZF_CTRL_T_COMMAND = "\${FZF_DEFAULT_COMMAND}";
      NIXPKGS_ALLOW_UNFREE = "1";
    }
    // lib.optionalAttrs config.vars.withGui {
      NIXOS_OZONE_WL = "1";
      TERM = "xterm-256color";
      # Fix for some Java AWT applications (e.g., Android Studio),
      # use this if they aren't displayed properly:
      "_JAVA_AWT_WM_NONREPARENTING" = "1";
      QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
      QT_QPA_PLATFORM = "wayland";
      SDL_VIDEODRIVER = "wayland";
      XDG_SESSION_TYPE = "wayland";
    };

    systemPackages = lib.attrValues {
      inherit (pkgs)
        # Networking and connectivity tools
        teavpn2 # Gnuweeb
        iputils # Tools like ping, tracepath, etc., for IP network diagnostics
        curl # Command-line tool for transferring data with URLs
        dnsutils # DNS-related tools like dig and nslookup
        nmap # Powerful network scanner for security auditing and discovery
        whois # Query domain registration info
        file # Determine file types, useful for identifying file formats

        # Clipboard and file operations
        rsync # Fast, versatile file copying/syncing tool
        wl-clipboard # Wayland clipboard tool (wl-copy/wl-paste)
        unzip # Extract .zip archives
        file-roller

        # Command-line utilities
        fd # User-friendly alternative to `find`
        fzf # Fuzzy finder for the terminal, useful in shells and editors
        jq # Command-line JSON processor
        ripgrep # Fast recursive search, better `grep`
        tealdeer # Fast, community-driven man pages (`tldr`)
        bottom # Graphical process/system monitor, like htop
        nix-index # Index all Nix packages for local search
        nh # Helper for managing NixOS systems and generations
        git # gud
        gh

        # Nix-related tools
        nixpkgs-review # Review pull requests or changes in nixpkgs locally

        # Secure Boot & system tools
        sbctl # Secure Boot key manager, useful for enrolling custom keys, debugging SB issues

        # Favorite desktop apps
        qbittorrent # Qt-based BitTorrent client with a clean UI
        imv # Minimalist image viewer for X11/Wayland
        viewnior # Lightweight image viewer, good for simple needs
        ente-auth # Ente authentication app (for encrypted cloud photo storage)
        thunderbird # Popular email client by Mozilla
        telegram-desktop # Desktop client for Telegram messaging app
        mpv # Highly configurable and efficient media player
        yazi # Blazing fast terminal file manager with preview support (like `lf`)
        ;

      # coreutils = pkgs.hiPrio pkgs.uutils-coreutils-noprefix;
      # findutils = pkgs.hiPrio pkgs.uutils-findutils;

      inherit (inputs'.nvim-flake.packages) nvim;
      inherit (self'.packages) gemini-cli;

      vesktop-wayland = pkgs.vesktop.overrideAttrs (old: {
        postFixup = ''
          ${old.postFixup or ""}
          # Rewrap vesktop to add Wayland-specific flags
          wrapProgram $out/bin/vesktop \
            --add-flags "--ozone-platform=wayland --enable-wayland-ime --wayland-text-input-version=3"
        '';
      });

      tidal-hifi = pkgs.tidal-hifi.overrideAttrs {
        /*
          #HACK:
          Remove space in the name to fix issue below

          ❯ fuzzel
          Invalid Entry ID 'TIDAL Hi-Fi.desktop'!
        */
        desktopItems = [
          (pkgs.makeDesktopItem {
            exec = "tidal-hifi";
            name = "tidal-hifi";
            desktopName = "Tidal Hi-Fi";
            genericName = "Tidal Hi-Fi";
            comment = "The web version of listen.tidal.com running in Electron with Hi-Fi support thanks to Widevine.";
            icon = "tidal-hifi";
            startupNotify = true;
            terminal = false;
            type = "Application";

            categories = [
              "AudioVideo"
              "Audio"
              "Network"
            ];

            startupWMClass = "tidal-hifi";
            mimeTypes = [ "x-scheme-handler/tidal" ];

            extraConfig = {
              "X-PulseAudio-Properties" = "media.role=music";
              "Keywords" = "music;streaming;tidal;hifi;lossless;";
            };
          })
        ];
      };

      # Use OCR and copy to clipboard
      wl-ocr =
        let
          inherit (lib) getExe getExe';

          tesseract = getExe pkgs.tesseract5;
          grim = getExe pkgs.grim;
          slurp = getExe pkgs.slurp;
          wl-copy = getExe' pkgs.wl-clipboard "wl-copy";
          notify-send = getExe pkgs.libnotify;
        in
        pkgs.writeShellScriptBin "wl-ocr" ''
          # 1. Select region (Exit if cancelled)
          GEOM=$(${slurp})
          if [ -z "$GEOM" ]; then exit 1; fi

          # 2. Extract Text
          # specify 'eng+ind+jpn' to keep the scan fast and accurate,
          TEXT=$(${grim} -g "$GEOM" -t ppm - | ${tesseract} -l eng+ind+jpn --psm 6 - -)

          # 3. Validation: Check if text is empty or just whitespace
          if [[ -z "''${TEXT//[[:space:]]/}" ]]; then
            ${notify-send} -u low "OCR Failed" "No readable text found."
            exit 1
          fi

          # 4. Copy to clipboard (strip null bytes)
          echo "$TEXT" | tr -d '\0' | ${wl-copy}

          # 5. Send Notification with a preview
          # Collapse newlines to spaces for the notification body
          PREVIEW=$(echo "$TEXT" | tr '\n' ' ' | cut -c 1-60)
          if [ ''${#TEXT} -gt 60 ]; then
            PREVIEW="''${PREVIEW}..."
          fi

          ${notify-send} "OCR Copied" "''${PREVIEW}"
        '';

      clipboard-picker = pkgs.writeShellScriptBin "clipboard-picker" ''
        ${pkgs.cliphist}/bin/cliphist list | \
        ${pkgs.fuzzel}/bin/fuzzel --dmenu | \
        ${pkgs.cliphist}/bin/cliphist decode | \
        ${pkgs.wl-clipboard}/bin/wl-copy
      '';
    };
  };

  # Nix command-not-found handler using programs database
  programs.command-not-found = {
    enable = true;
    dbPath = inputs'.programsdb.packages.programs-sqlite;
  };
  environment.etc."programs.sqlite".source =
    inputs'.programsdb.packages.programs-sqlite;

  programs = {
    evince.enable = config.vars.withGui; # Document Viewer
    thunar = {
      enable = config.vars.withGui;
      plugins = with pkgs.xfce; [
        thunar-archive-plugin
        thunar-volman
      ];
    };
  };
  services = {
    gvfs.enable = config.vars.withGui; # Mount, trash, and other functionalities
    tumbler.enable = config.vars.withGui; # Thumbnail support for images
  };

  security = {
    sudo = {
      enable = true;
      extraConfig = ''
        # Rollback results in sudo lectures after each reboot
        Defaults lecture = never

        # Show asterisk when typing password
        Defaults pwfeedback

        # Increases the timeout to 30 minutes (default is 15).
        # Less typing your password while working on long tasks.
        Defaults timestamp_timeout=30

        # Preserves preferred editor and terminal colors when running sudo.
        # This prevents 'sudo vim' from looking like shit or defaulting to nano.
        Defaults env_keep += "EDITOR VISUAL TERM"
      '';
    };
  };

  services = {
    # Service that makes Out of Memory Killer more effective
    earlyoom.enable = true;

    # Enable periodic SSD TRIM of mounted partitions in background
    fstrim.enable = true;

    playerctld.enable = config.vars.withGui;
  };

  systemd.services.nix-daemon = lib.mkIf config.boot.tmp.useTmpfs {
    environment.TMPDIR = "/var/tmp";
  };
  nix = {
    nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];

    # Improve Nix store disk usage
    optimise.automatic = true;

    settings = {
      experimental-features = [
        # Enable Flakes.
        "flakes"

        # Enable nix3-command.
        "nix-command"

        # Allows Lix to invoke a custom command via its main binary `lix`,
        # i.e. `lix-foo` gets invoked when `lix foo` is executed.
        # "lix-custom-sub-commands"

        # Allows Nix to automatically pick UIDs for builds, rather than creating `nixbld*` user accounts.
        "auto-allocate-uids"
      ];

      # Allow Lix to import from a derivation, allowing building at evaluation time.
      allow-import-from-derivation = true;

      # Prevent impurities in builds
      sandbox = pkgs.stdenv.hostPlatform.isLinux;

      # Keep building derivations when another build fails.
      keep-going = true;

      # The number of lines of the tail of the log to show if a build fails.
      log-lines = 30;

      # The commit summary to use when committing changed Flake lock files.
      commit-lockfile-summary = "chore: Update flake.lock";

      # Accept Nix configurations from Flake without prompting
      # Dangerous!
      accept-flake-config = false;

      # If set to true, Nix automatically detects files in the store that have identical contents,
      # and replaces them with hard links to a single copy.
      auto-optimise-store = true;

      # If set to true, Nix will conform to the XDG Base Directory Specification for files in $HOME.
      use-xdg-base-directories = true;

      # For GC roots.
      # If true (default), the garbage collector will keep the derivations from which non-garbage store paths were built
      keep-derivations = true;

      # If true, the garbage collector will keep the outputs of non-garbage derivations.
      keep-outputs = true;

      # Whether to warn about dirty Git/Mercurial trees.
      warn-dirty = false;

      narinfo-cache-positive-ttl = 3600;

      # Give group special Nix privileges.
      trusted-users = [ "@wheel" ];
      allowed-users = [ "@wheel" ];

      substituters = [
        # The default is https://cache.nixos.org, which has a priority of 40.
        # Lower value means higher priority.
        "https://cache.nixos.org?priority=10"
        "https://chaotic-nyx.cachix.org?priority=30"
        "https://cache.garnix.io?priority=40"
      ];

      trusted-public-keys = [
        "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
        "chaotic-nyx.cachix.org-1:HfnXSw4pj95iI/n17rIDy40agHj12WfF+Gqk6SonIT8="
      ];
    };

    registry = {
      system.flake = inputs.nixpkgs;
      default.flake = inputs.nixpkgs;
      nixpkgs.flake = inputs.nixpkgs;
    };
  };
  system.stateVersion = config.vars.stateVersion;
}
