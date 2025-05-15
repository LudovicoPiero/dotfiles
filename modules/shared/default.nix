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
    # inputs.lix-module.nixosModules.default
    inputs.determinate.nixosModules.default

    ./users.nix
    ./security.nix
    ./hjem.nix
  ];

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowUnfreePredicate = _: true;
  hardware.enableRedistributableFirmware = lib.mkDefault true;
  hardware.enableAllFirmware = true;
  time.timeZone = config.vars.timezone;

  system.switch = {
    enable = false;
    enableNg = true;
  };

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

  environment.systemPackages = lib.attrValues {
    inherit (pkgs)
      teavpn2
      adwaita-icon-theme
      bat
      iputils
      curl
      dnsutils
      fd
      fzf
      sbctl # For debugging and troubleshooting Secure boot.

      bottom
      jq
      nix-index
      nmap
      ripgrep
      tealdeer
      whois
      wl-clipboard-rs
      wget
      unzip
      # Utils for nixpkgs stuff
      nixpkgs-review
      # Fav
      element-desktop # matrix client
      # fooyin # music player
      foliate # book reader
      qbittorrent # uhm
      imv
      viewnior
      ente-auth
      thunderbird
      telegram-desktop
      mpv
      yazi
      nh
      tidal-hifi
      ;

    coreutils = pkgs.hiPrio pkgs.uutils-coreutils-noprefix;
    findutils = pkgs.hiPrio pkgs.uutils-findutils;

    # use OCR and copy to clipboard
    wl-ocr =
      let
        _ = lib.getExe;
      in
      pkgs.writeShellScriptBin "wl-ocr" ''
        ${_ pkgs.grim} -g "$(${_ pkgs.slurp})" -t ppm - | ${_ pkgs.tesseract5} - - | ${pkgs.wl-clipboard-rs}/bin/wl-copy
        ${_ pkgs.libnotify} "$(${pkgs.wl-clipboard-rs}/bin/wl-paste)"
      '';
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
  };

  systemd.services.nix-daemon = lib.mkIf config.boot.tmp.useTmpfs {
    environment.TMPDIR = "/var/tmp";
  };
  nix = {
    nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];

    settings = {
      experimental-features = [
        # Enable flakes.
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

      # Give root user and wheel group special Nix privileges.
      trusted-users = [
        "root"
        "@wheel"
      ];
      allowed-users = [ "@wheel" ];

      substituters = [
        # The default is https://cache.nixos.org, which has a priority of 40.
        # Lower value means higher priority.
        "https://cache.nixos.org?priority=10"
        "https://nix-community.cachix.org?priority=20"
        "https://cache.garnix.io?priority=40"
      ];

      trusted-public-keys = [
        "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
    };

    registry = {
      system.flake = inputs.nixpkgs;
      default.flake = inputs.nixpkgs;
      nixpkgs.flake = inputs.nixpkgs;
    };

    # Improve nix store disk usage
    optimise.automatic = true;
  };
  system.stateVersion = config.vars.stateVersion;
}
