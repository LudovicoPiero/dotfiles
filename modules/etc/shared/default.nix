{
  lib,
  inputs,
  pkgs,
  config,
  ...
}:
{
  # Nixos Stuff
  imports = [
    ./users.nix
    ./security.nix
    ./home-manager.nix
  ];

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowUnfreePredicate = _: true;
  hardware.enableRedistributableFirmware = lib.mkDefault true;
  hardware.enableAllFirmware = true;
  time.timeZone = config.vars.timezone;

  programs = {
    command-not-found.dbPath =
      inputs.programsdb.packages.${pkgs.stdenv.hostPlatform.system}.programs-sqlite;
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
    systemPackages = lib.attrValues {
      inherit (pkgs)
        # Networking and connectivity tools
        teavpn2
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

      coreutils = pkgs.hiPrio pkgs.uutils-coreutils-noprefix;
      findutils = pkgs.hiPrio pkgs.uutils-findutils;

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
            comment = "The web version of listen.tidal.com running in electron with hifi support thanks to widevine.";
            icon = "tidal-hifi";
            startupNotify = true;
            terminal = false;
            type = "Application";
            categories = [
              "Network"
              "Application"
              "AudioVideo"
              "Audio"
              "Video"
            ];
            startupWMClass = "tidal-hifi";
            mimeTypes = [ "x-scheme-handler/tidal" ];
            extraConfig.X-PulseAudio-Properties = "media.role=music";
          })
        ];

      };

      # use OCR and copy to clipboard
      wl-ocr =
        let
          _ = lib.getExe;
        in
        pkgs.writeShellScriptBin "wl-ocr" ''
          ${_ pkgs.grim} -g "$(${_ pkgs.slurp})" -t ppm - | ${_ pkgs.tesseract5} - - | ${pkgs.wl-clipboard}/bin/wl-copy
          ${_ pkgs.libnotify} "$(${pkgs.wl-clipboard}/bin/wl-paste)"
        '';
    };
  };

  programs = {
    evince.enable = config.vars.withGui; # Document Viewer
    file-roller.enable = config.vars.withGui; # Archive Manager

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
        # rollback results in sudo lectures after each reboot
        Defaults lecture = never

        # Show asterisk when typing password
        Defaults pwfeedback
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

    # Use latest nix
    package = pkgs.nixVersions.git;

    # Improve nix store disk usage
    optimise.automatic = true;

    settings = {
      experimental-features = [
        # Enable flakes.
        "flakes"

        # Enable nix3-command.
        "nix-command"

        # Allows Nix to automatically pick UIDs for builds, rather than creating `nixbld*` user accounts.
        "auto-allocate-uids"
      ];

      # Allow Nix to import from a derivation, allowing building at evaluation time.
      allow-import-from-derivation = true;

      # Prevent impurities in builds
      sandbox = pkgs.stdenv.hostPlatform.isLinux;

      # Keep building derivations when another build fails.
      keep-going = true;

      # The number of lines of the tail of the log to show if a build fails.
      log-lines = 30;

      # The commit summary to use when committing changed flake lock files.
      commit-lockfile-summary = "chore: Update flake.lock";

      # Accept nix configurations from flake without prompting
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
        "https://cache.garnix.io?priority=40"
      ];

      trusted-public-keys = [ "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g=" ];
    };

    registry = {
      system.flake = inputs.nixpkgs;
      default.flake = inputs.nixpkgs;
      nixpkgs.flake = inputs.nixpkgs;
    };
  };
  system.stateVersion = config.vars.stateVersion;
}
