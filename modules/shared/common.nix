{
  config,
  lib,
  inputs,
  pkgs,
  ...
}:
{
  nixpkgs.config.allowUnfree = true;
  hardware.enableRedistributableFirmware = lib.mkDefault true;
  hardware.enableAllFirmware = true;
  time.timeZone = config.mine.vars.timezone;

  # Install bloat
  environment.systemPackages = lib.attrValues {
    inherit (pkgs)
      # Core / Utilities
      tmux # Terminal multiplexer
      eza # Modern replacement for 'ls'
      wget # Tool for retrieving files using HTTP, HTTPS, and FTP
      curl # Command line tool for transferring data with URLs
      git # Distributed version control system
      gh # GitHub CLI tool
      bat # Cat clone with syntax highlighting and Git integration
      fd # Simple, fast and user-friendly alternative to 'find'
      ripgrep # Fast line-oriented search tool (grep alternative)
      fzf # Command-line fuzzy finder
      jq # Lightweight and flexible command-line JSON processor
      tealdeer # Fast implementation of tldr (simplified man pages)
      bottom # Cross-platform graphical process/system monitor
      unzip # Extraction utility for .zip compressed archives
      file # Utility to determine the type of a file
      file-roller # Archive manager for the GNOME desktop environment
      wl-clipboard # Command-line copy/paste utilities for Wayland
      cliphist # Wayland clipboard manager
      rsync # Fast incremental file transfer utility
      nix-index # Database of all files in nixpkgs (provides command-not-found)
      nh # Yet another nix CLI helper for managing configurations
      nixpkgs-review # Tool to review nixpkgs pull requests locally
      sbctl # Secure Boot key manager

      # Networking
      teavpn2 # SSL VPN client
      iputils # Network monitoring tools (ping, tracepath, etc.)
      dnsutils # DNS utilities (dig, nslookup)
      nmap # Network exploration tool and security / port scanner
      whois # Client for the WHOIS directory service

      # GUI Apps
      qbittorrent # Free and open-source BitTorrent client
      imv # Image viewer intended for use with tiling window managers
      viewnior # Simple, fast and elegant image viewer
      ente-auth # Open source 2FA authenticator (Desktop client)
      thunderbird # Full-featured email, RSS, and newsgroup client
      telegram-desktop # Official desktop client for Telegram
      mpv # General-purpose media player
      vesktop # Custom Discord client with Vencord embedded
      # tidal-hifi # Web wrapper for Tidal music streaming

      # Terminal Apps
      yazi # Blazing fast terminal file manager written in Rust
      ;

    # Flake Packages
    nvim = inputs.nvim-flake.packages.${pkgs.stdenv.hostPlatform.system}.default; # Custom Neovim configuration
  };

  # Nix command-not-found handler using programs database
  programs.command-not-found = {
    enable = true;
    dbPath =
      inputs.programsdb.packages.${pkgs.stdenv.hostPlatform.system}.programs-sqlite;
  };
  environment.etc."programs.sqlite".source =
    inputs.programsdb.packages.${pkgs.stdenv.hostPlatform.system}.programs-sqlite;

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

  programs = {
    evince.enable = config.mine.vars.withGui; # Document Viewer
    thunar = {
      enable = config.mine.vars.withGui;
      plugins = with pkgs; [
        thunar-archive-plugin
        thunar-volman
      ];
    };
  };

  services = {
    gvfs.enable = config.mine.vars.withGui; # Mount, trash, and other functionalities
    tumbler.enable = config.mine.vars.withGui; # Thumbnail support for images

    # Use dbus-broker
    dbus.implementation = "broker";

    angrr = {
      enable = true;
      enableNixGcIntegration = true;
      settings = {
        profile-policies = {
          system = {
            keep-booted-system = true;
            keep-current-system = true;
            keep-latest-n = 5;
            keep-since = "14d";
            profile-paths = [ "/nix/var/nix/profiles/system" ];
          };
          user = {
            enable = false;
            keep-booted-system = false;
            keep-current-system = false;
            keep-latest-n = 1;
            keep-since = "1d";
            profile-paths = [
              "~/.local/state/nix/profiles/profile"
              "/nix/var/nix/profiles/per-user/root/profile"
            ];
          };
        };
        temporary-root-policies = {
          direnv = {
            path-regex = "/\\.direnv/";
            period = "14d";
          };
          result = {
            path-regex = "/result[^/]*$";
            period = "3d";
          };
        };
      };
    };

    # Service that makes Out of Memory Killer more effective
    earlyoom.enable = true;

    # Enable periodic SSD TRIM of mounted partitions in background
    fstrim.enable = true;

    # Enable playerctl for media key support
    playerctld.enable = config.mine.vars.withGui;
  };

  # Show a pretty diff
  system = {
    # https://github.com/pluiedev/flake/blob/main/systems/laptop.nix#L102
    # Thank @luishfonseca for this
    # https://github.com/luishfonseca/dotfiles/blob/ab7625ec406b48493eda701911ad1cd017ce5bc1/modules/upgrade-diff.nix
    activationScripts.diff = {
      supportsDryActivation = true;
      text = ''
        ${lib.getExe pkgs.nvd} --nix-bin-dir=${pkgs.nix}/bin diff /run/current-system "$systemConfig"
      '';
    };
  };

  systemd.services.nix-daemon = lib.mkIf config.boot.tmp.useTmpfs {
    environment.TMPDIR = "/var/tmp";
  };

  nix = {
    gc.automatic = true; # For angrr
    registry = {
      system.flake = inputs.nixpkgs;
      default.flake = inputs.nixpkgs;
      nixpkgs.flake = inputs.nixpkgs;
    };

    settings = {
      # Give group special Nix privileges.
      trusted-users = [ "@wheel" ];
      allowed-users = [ "@wheel" ];

      # The number of lines of the tail of the log to show if a build fails.
      log-lines = 30;

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

      # https://bmcgee.ie/posts/2023/12/til-how-to-optimise-substitutions-in-nix/
      http-connections = 128;
      max-substitution-jobs = 128;

      narinfo-cache-positive-ttl = 3600;

      # The commit summary to use when committing changed Flake lock files.
      commit-lockfile-summary = "chore: Update flake.lock";

      experimental-features = [
        # Enable Flakes
        "nix-command"
        "flakes"

        # Allows Nix to automatically pick UIDs for builds, rather than creating `nixbld*` user accounts.
        "auto-allocate-uids"
      ];
      extra-substituters = [
        "https://nix-community.cachix.org"
        "https://cache.garnix.io"
      ];
      extra-trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
      ];
    };
  };
}
