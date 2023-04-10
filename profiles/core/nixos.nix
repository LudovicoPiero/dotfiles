{
  pkgs,
  ...
}: {
  imports = [
    ./common.nix
  ];

  security = {
    # polkit.enable = true;
    sudo.enable = false;
    doas = {
      enable = true;
      extraRules = [
        {
          users = ["ludovico"];
          keepEnv = true;
          persist = true;
        }
      ];
    };
  };

  environment = {
    # completion for system packages (e.g. systemd).
    pathsToLink = ["/share/fish"];
    # Selection of sysadmin tools that can come in handy
    systemPackages = with pkgs; [
      dosfstools
      gptfdisk
      iputils
      usbutils
      utillinux
    ];
    sessionVariables = {
      # silence direnv warnings for "long running commands"
      DIRENV_WARN_TIMEOUT = "24h";
      # silence direnv
      DIRENV_LOG_FORMAT = "";
      MANGOHUD = "1"; # Launch all vulkan games with mangohud
    };
  };

  nix = {
    settings = {
      # Prevent impurities in builds
      sandbox = true;

      # Give root user and wheel group special Nix privileges.
      trusted-users = ["root" "@wheel"];
      allowed-users = ["@wheel"];
    };

    # Improve nix store disk usage
    settings.auto-optimise-store = true;
    optimise.automatic = true;
  };

  # For rage encryption, all hosts need a ssh key pair
  # services.openssh = {
  #   enable = true;
  #   openFirewall = lib.mkDefault false;
  # };

  # Service that makes Out of Memory Killer more effective
  services.earlyoom.enable = true;
}
