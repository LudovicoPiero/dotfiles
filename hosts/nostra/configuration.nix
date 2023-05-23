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
    secrets = let
      default = {
        owner = "wireguard";
        mode = "0640";
        reloadUnits = ["systemd-networkd.service"];
      };
    in {
      cosa.neededForUsers = true;
      root.neededForUsers = true;
      wireguardPrivateKey = default;
      wireguardPublicKey = default;
      wireguardPreshared-pc = default;
      wireguardPreshared-phone = default;
    };
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

  # Enable NAT
  networking.nat = {
    enable = true;
    enableIPv6 = true;
    externalInterface = "eth0";
    internalInterfaces = ["wg0"];
  };
  # Open ports in the firewall
  networking.firewall = {
    allowedTCPPorts = [53 22];
    allowedUDPPorts = [53 52780];
  };

  # Wireguard Server
  services = {
    dnsmasq = {
      enable = true;
      settings = {
        interface = "wg0";
      };
    };
  };
  networking.wg-quick.interfaces = {
    # "wg0" is the network interface name. You can name the interface arbitrarily.
    wg0 = {
      # Determines the IP/IPv6 address and subnet of the client's end of the tunnel interface
      address = ["10.66.66.1/24" "fdc9:281f:04d7:9ee9::1/64"];
      # The port that WireGuard listens to - recommended that this be changed from default
      listenPort = 52780;
      # Path to the server's private key
      privateKeyFile = config.sops.secrets.wireguardPrivateKey.path;

      # This allows the wireguard server to route your traffic to the internet and hence be like a VPN
      postUp = ''
        ${pkgs.iptables}/bin/iptables -A FORWARD -i wg0 -j ACCEPT
        ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -s 10.0.0.1/24 -o eth0 -j MASQUERADE
        ${pkgs.iptables}/bin/ip6tables -A FORWARD -i wg0 -j ACCEPT
        ${pkgs.iptables}/bin/ip6tables -t nat -A POSTROUTING -s fdc9:281f:04d7:9ee9::1/64 -o eth0 -j MASQUERADE
      '';

      # Undo the above
      preDown = ''
        ${pkgs.iptables}/bin/iptables -D FORWARD -i wg0 -j ACCEPT
        ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -s 10.0.0.1/24 -o eth0 -j MASQUERADE
        ${pkgs.iptables}/bin/ip6tables -D FORWARD -i wg0 -j ACCEPT
        ${pkgs.iptables}/bin/ip6tables -t nat -D POSTROUTING -s fdc9:281f:04d7:9ee9::1/64 -o eth0 -j MASQUERADE
      '';

      peers = [
        {
          # pc
          publicKey = config.sops.secrets.wireguardPublicKey.path;
          presharedKeyFile = config.sops.secrets.wireguardPreshared-pc.path;
          allowedIPs = ["10.66.66.2/32" "fdc9:281f:04d7:9ee9::2/128"];
        }
        {
          # phone
          publicKey = config.sops.secrets.wireguardPublicKey.path;
          presharedKeyFile = config.sops.secrets.wireguardPreshared-phone.path;
          allowedIPs = ["10.66.66.3/32" "fdc9:281f:04d7:9ee9::3/128"];
        }
      ];
    };
  };
}
