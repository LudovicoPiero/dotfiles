{
  config,
  pkgs,
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
        # owner = "wireguard";
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
      PermitRootLogin = "no";
      PasswordAuthentication = false;
    };
  };

  ##TODO: Currently no worky
  # enable NAT
  networking.nat.enable = true;
  networking.nat.externalInterface = "ens3";
  networking.nat.internalInterfaces = ["wg0"];
  networking.firewall = {
    allowedUDPPorts = [51820];
  };

  networking.wireguard.interfaces = {
    wg0 = {
      ips = ["10.100.0.1/24"];
      # The port that WireGuard listens to. Must be accessible by the client.
      listenPort = 51820;
      postSetup = ''
        ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -s 10.100.0.0/24 -o eth0 -j MASQUERADE
      '';
      postShutdown = ''
        ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -s 10.100.0.0/24 -o eth0 -j MASQUERADE
      '';
      privateKeyFile = "/home/cosa/wireguard-keys/private";

      peers = [
        # List of allowed peers.
        {
          # Feel free to give a meaning full name
          # Public key of the peer (not a file path).
          publicKey = "FCq5ME9IglSSZR3kNzfyM935hho9c3C+Y5cbMG1PyCM=";
          # List of IPs assigned to this peer within the tunnel subnet. Used to configure routing.
          allowedIPs = ["10.100.0.2/32"];
        }
        # {
        #   # John Doe
        #   publicKey = "{john doe's public key}";
        #   allowedIPs = ["10.100.0.3/32"];
        # }
      ];
    };
  };
}
