{
  lib,
  inputs,
  pkgs,
  config,
  ...
}:
{
  # Home-Manager Stuff
  home-manager.backupFileExtension = "hm.bak";
  home-manager.users.${config.myOptions.vars.username} = {
    home.stateVersion = config.myOptions.vars.stateVersion;
  };

  # Nixos Stuff
  hardware.enableRedistributableFirmware = lib.mkDefault true;
  time.timeZone = config.myOptions.vars.timezone;

  environment = {
    systemPackages = with pkgs; [
      teavpn2
      adwaita-icon-theme
      dosfstools
      gptfdisk
      iputils
      usbutils
      utillinux
      binutils
      coreutils
      curl
      direnv
      dnsutils
      fd
      sbctl # For debugging and troubleshooting Secure boot.

      bottom
      jq
      moreutils
      nix-index
      nmap
      skim
      ripgrep
      tealdeer
      whois
      wl-clipboard
      wget
      unzip

      # Utils for nixpkgs stuff
      nixpkgs-review
    ];
  };

  programs = {
    dconf.enable = true;
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
    dbus.packages = [ pkgs.gcr ];

    # Enable periodic SSD TRIM of mounted partitions in background
    fstrim.enable = true;

    # Location for gammastep
    # geoclue2 = {
    #   enable = true;
    #   appConfig.gammastep = {
    #     isAllowed = true;
    #     isSystem = false;
    #   };
    # };
  };

  nix = {
    nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];

    settings = {
      # Prevent impurities in builds
      sandbox = true;

      experimental-features = [
        "auto-allocate-uids"
        "ca-derivations"
        # "configurable-impure-env"
        "flakes"
        "no-url-literals"
        "nix-command"
        "parse-toml-timestamps"
        "read-only-local-store"
        "recursive-nix"
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
        "https://cache.privatevoid.net?priority=41"
        "https://sforza-config.cachix.org?priority=42"
        "https://nix-community.cachix.org?priority=43"
        "https://nyx.chaotic.cx?priority=44"
        "https://hyprland.cachix.org?priority=45"
        "https://cache.garnix.io?priority=60"
      ];

      trusted-public-keys = [
        "cache.privatevoid.net:SErQ8bvNWANeAvtsOESUwVYr2VJynfuc9JRwlzTTkVg="
        "sforza-config.cachix.org-1:qQiEQ1JU25VqhRXi1Qr/kA8RT01pd7oeKHr5OORUolM="
        "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
        "nyx.chaotic.cx-1:HfnXSw4pj95iI/n17rIDy40agHj12WfF+Gqk6SonIT8="
        "chaotic-nyx.cachix.org-1:HfnXSw4pj95iI/n17rIDy40agHj12WfF+Gqk6SonIT8="
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
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
      options = "--delete-older-than 3d";
    };
    optimise.automatic = true;
  };

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = config.myOptions.vars.stateVersion; # Did you read the comment?

}
