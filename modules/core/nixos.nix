{
  pkgs,
  inputs,
  ...
}: {
  nixpkgs.config = {
    permittedInsecurePackages = [
      "mailspring-1.11.0"
    ];
    allowUnfree = true;
  };

  systemd.services.NetworkManager-wait-online.enable = false;

  security = {
    # polkit.enable = true;
    sudo = {
      enable = true;
      extraConfig = ''
        # rollback results in sudo lectures after each reboot
        Defaults lecture = never

        # Show asterisk when typing password
        Defaults pwfeedback
      '';
    };
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
      nixpkgs-lint-community
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

      experimental-features = [
        "auto-allocate-uids"
        "ca-derivations"
        "configurable-impure-env"
        "flakes"
        "no-url-literals"
        "nix-command"
        "parse-toml-timestamps"
        "read-only-local-store"
      ];

      keep-derivations = true;
      keep-outputs = true;

      fallback = true;

      # Give root user and wheel group special Nix privileges.
      trusted-users = ["root" "@wheel"];
      allowed-users = ["@wheel"];

      substituters = [
        "https://cache.garnix.io"
        "https://sforza-config.cachix.org"
        "https://cache.privatevoid.net"
        "https://nixpkgs-unfree.cachix.org"
        "https://numtide.cachix.org"
      ];

      trusted-public-keys = [
        "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
        "sforza-config.cachix.org-1:qQiEQ1JU25VqhRXi1Qr/kA8RT01pd7oeKHr5OORUolM="
        "cache.privatevoid.net:SErQ8bvNWANeAvtsOESUwVYr2VJynfuc9JRwlzTTkVg="
        "nixpkgs-unfree.cachix.org-1:hqvoInulhbV4nJ9yJOEr+4wxhDV4xq2d1DK7S6Nj6rs="
        "numtide.cachix.org-1:2ps1kLBUWjxIneOy1Ik6cQjb41X0iXVXeHigGmycPPE="
      ];
    };

    registry = {
      system.flake = inputs.master;
      default.flake = inputs.master;
      nixpkgs.flake = inputs.master;
    };

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
