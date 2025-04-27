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
    ./home-manager.nix # Home-Manager stuff
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
  };

  # Nautilus / File Manager
  environment.systemPackages = lib.attrValues {
    inherit (pkgs)
      teavpn2
      adwaita-icon-theme
      bat
      iputils
      curl
      direnv
      dnsutils
      fd
      fzf
      sbctl # For debugging and troubleshooting Secure boot.
      nautilus

      bottom
      jq
      nix-index
      nmap
      ripgrep
      tealdeer
      whois
      wl-clipboard
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
      ;

    coreutils = pkgs.hiPrio pkgs.uutils-coreutils-noprefix;
    findutils = pkgs.hiPrio pkgs.uutils-findutils;
    tidal-hifi = inputs.self.packages.${pkgs.stdenv.hostPlatform.system}.tidal-hifi;

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

  programs = {
    evince.enable = config.vars.withGui; # Document Viewer
    file-roller.enable = config.vars.withGui; # Archive Manager
    nautilus-open-any-terminal = {
      enable = config.vars.withGui;
      terminal = "${config.vars.terminal}";
    };
  };
  services = {
    gvfs.enable = config.vars.withGui; # Mount, trash, and other functionalities
    tumbler.enable = config.vars.withGui; # Thumbnail support for images
    gnome = {
      sushi.enable = config.vars.withGui; # quick previewer for nautilus
      glib-networking.enable = config.vars.withGui; # network extensions libs
    };
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
    package = pkgs.nixVersions.latest;

    settings = {
      # Prevent impurities in builds
      sandbox = true;

      experimental-features = [
        "flakes"
        "nix-command"
      ];

      commit-lockfile-summary = "chore: Update flake.lock";
      accept-flake-config = true;
      auto-optimise-store = true;
      keep-derivations = true;
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
        /*
          The default is https://cache.nixos.org, which has a priority of 40.
          Lower value means higher priority.
        */
        "https://nix-community.cachix.org?priority=43"
        "https://nyx.chaotic.cx?priority=44"
        "https://cache.garnix.io?priority=60"
      ];

      trusted-public-keys = [
        "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "nyx.chaotic.cx-1:HfnXSw4pj95iI/n17rIDy40agHj12WfF+Gqk6SonIT8="
        "chaotic-nyx.cachix.org-1:HfnXSw4pj95iI/n17rIDy40agHj12WfF+Gqk6SonIT8="
      ];
    };

    registry = {
      system.flake = inputs.nixpkgs;
      default.flake = inputs.nixpkgs;
      nixpkgs.flake = inputs.nixpkgs;
    };

    # Improve nix store disk usage
    gc = {
      automatic = true;
      options = "--delete-older-than 30d";
    };
    optimise.automatic = true;
  };
  system.stateVersion = config.vars.stateVersion;
}
