{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./hardware-configuration.nix

    ../shared/configuration.nix
  ];

  # Don't care
  documentation.nixos.enable = false;

  sops = {
    defaultSopsFile = ./secrets.yaml;
    age.sshKeyPaths = ["/home/cosa/.ssh/id_rsa"];
    secrets.cosa.neededForUsers = true;
    secrets.root.neededForUsers = true;
  };

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    loader.grub.enable = true;
    loader.grub.device = "/dev/vda"; # or "nodev" for efi only
  };

  time.timeZone = "Australia/Brisbane";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  users = {
    mutableUsers = false;
    users.root.passwordFile = config.sops.secrets.root.path;
    users.cosa = {
      passwordFile = config.sops.secrets.cosa.path;
      isNormalUser = true;
      home = "/home/cosa";

      extraGroups = ["wheel"];
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILHKPBn388QwATBB2GiXYirTYZ+Nd2GTbzaUryyuWi3A"
      ];
    };
  };

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    settings = {
      permitRootLogin = "no";
      passwordAuthentication = false;
    };
  };

  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;
  # Enable NAT
  networking.nat = {
    enable = true;
    enableIPv6 = true;
    externalInterface = "eth0";
    internalInterfaces = ["wg0"];
  };
  # Open ports in the firewall
  networking.firewall = {
    allowedTCPPorts = [53];
    allowedUDPPorts = [53 51820];
  };
}
