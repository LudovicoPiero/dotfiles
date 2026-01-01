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
  };

  services = {
    # Service that makes Out of Memory Killer more effective
    earlyoom.enable = true;

    # Enable periodic SSD TRIM of mounted partitions in background
    fstrim.enable = true;

    playerctld.enable = config.mine.vars.withGui;
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
