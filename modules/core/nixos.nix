{
  pkgs,
  inputs,
  ...
}: {
  nixpkgs.config = {
    allowUnfree = true;
    allowBroken = true; # ZFS Stuff
  };

  security = {
    # polkit.enable = true;
    sudo.enable = true;
    doas = {
      enable = false;
      extraRules = [
        {
          users = ["ludovico"];
          keepEnv = true;
          persist = true;
        }
      ];
    };
  };

  services = {
    # Service that makes Out of Memory Killer more effective
    earlyoom.enable = true;
    dbus.packages = [pkgs.gcr];
  };

  environment = {
    # completion for system packages (e.g. systemd).
    pathsToLink = ["/share/fish"];

    # Selection of sysadmin tools that can come in handy
    systemPackages = with pkgs; [
      teavpn2
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

      pwvucontrol
      git
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
      # haskellPackages.nixpkgs-update #FIXME: remove comment if fixed upstream
    ];

    sessionVariables = {
      # Used by nh.
      FLAKE = "/home/ludovico/.config/nixos";

      # silence direnv warnings for "long running commands"
      DIRENV_WARN_TIMEOUT = "24h";
      # silence direnv
      DIRENV_LOG_FORMAT = "";
      #   MANGOHUD = "1"; # Launch all vulkan games with mangohud
    };
  };

  nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 3d --keep 3";
  };

  nix = {
    nixPath = ["nixpkgs=flake:nixpkgs"]; # https://ayats.org/blog/channels-to-flakes/

    package = inputs.nix-super.packages.${pkgs.system}.nix;

    settings = {
      # Prevent impurities in builds
      sandbox = true;

      auto-optimise-store = true;

      # Give root user and wheel group special Nix privileges.
      trusted-users = ["root" "@wheel"];
      allowed-users = ["@wheel"];

      substituters = [
        "https://cache.garnix.io"
        "https://sforza-config.cachix.org"
      ];

      trusted-public-keys = [
        "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
        "sforza-config.cachix.org-1:qQiEQ1JU25VqhRXi1Qr/kA8RT01pd7oeKHr5OORUolM="
      ];
    };

    registry = {
      system.flake = inputs.master;
      default.flake = inputs.master;
      nixpkgs.flake = inputs.master;
    };

    extraOptions = ''
      min-free = 536870912
      keep-outputs = true
      keep-derivations = true
      fallback = true
      experimental-features = nix-command flakes ca-derivations
    '';

    # Improve nix store disk usage
    # Disable this because i'm using nh.
    # gc = {
    #   automatic = true;
    #   options = "--delete-older-than 3d";
    # };
    optimise.automatic = true;
  };

  # For rage encryption, all hosts need a ssh key pair
  # services.openssh = {
  #   enable = true;
  #   openFirewall = lib.mkDefault false;
  # };
}
