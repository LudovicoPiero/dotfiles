{
  lib,
  inputs,
  pkgs,
  config,
  ...
}: {
  # Nixos Stuff
  imports = [
    inputs.lix-module.nixosModules.default
    inputs.hosts.nixosModule

    ./users.nix
    ./security.nix
    ./home-manager.nix # Home-Manager stuff
  ];

  hardware.enableRedistributableFirmware = lib.mkDefault true;
  time.timeZone = config.myOptions.vars.timezone;

  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      "symbola"
    ];

  programs = {
    dconf.enable = true;

    thunar = {
      enable = config.myOptions.vars.withGui;
      plugins = with pkgs.xfce; [
        thunar-archive-plugin
        thunar-volman
      ];
    };
  };

  services = {
    gvfs.enable = config.programs.thunar.enable; # Mount, trash, and other functionalities
    tumbler.enable = config.programs.thunar.enable; # Thumbnail support for images
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

  nix = {
    nixPath = ["nixpkgs=${inputs.nixpkgs}"];

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
      allowed-users = ["@wheel"];

      substituters = [
        /*
        The default is https://cache.nixos.org, which has a priority of 40.
        Lower value means higher priority.
        */
        "https://sforza-config.cachix.org?priority=42"
        "https://nix-community.cachix.org?priority=43"
        "https://nyx.chaotic.cx?priority=44"
        "https://hyprland.cachix.org?priority=45"
        "https://cache.garnix.io?priority=60"
      ];

      trusted-public-keys = [
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
  system.stateVersion = config.myOptions.vars.stateVersion;
}
