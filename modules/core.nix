{ pkgs, inputs, ... }: {
  boot = {
    loader = {
      systemd-boot.enable = true;
      systemd-boot.configurationLimit = 10;
      efi.canTouchEfiVariables = true;
    };

    kernelPackages = pkgs.linuxPackages_xanmod_latest;
  };

  networking.hostName = "unit-01";
  networking.networkmanager.enable = true;

  time.timeZone = "Asia/Jakarta";

  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 3d --keep  3";
    flake = "/home/rei/Code/dotfiles";
  };

  nix = {
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

      substituters = [ "https://nix-gaming.cachix.org" ];
      trusted-public-keys = [
        "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
      ];
    };
  };
}
