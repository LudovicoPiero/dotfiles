{
  inputs,
  cell,
  lib,
  config,
}:
let
  inherit (inputs) nixpkgs;
  inherit (cell) bee system;
in
{
  inherit bee;

  imports = [
    system.common
    inputs.impermanence.nixosModules.impermanence
    inputs.lanzaboote.nixosModules.lanzaboote
  ];

  #TODO:
  environment.systemPackages = with nixpkgs; [
    firefox
    vesktop
    wezterm
    element-desktop
    kitty
  ];
  hardware.pulseaudio.enable = lib.mkForce false;
  services.power-profiles-daemon.enable = lib.mkForce false; # Conflict with TLP
  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  environment.gnome.excludePackages =
    (with nixpkgs; [
      gnome-photos
      gnome-tour
      gedit # text editor
    ])
    ++ (with nixpkgs.gnome; [
      cheese # webcam tool
      gnome-music
      gnome-terminal
      epiphany # web browser
      geary # email reader
      evince # document viewer
      gnome-characters
      totem # video player
      tali # poker game
      iagno # go game
      hitori # sudoku game
      atomix # puzzle game
    ]);

  documentation = {
    enable = true;
    doc.enable = true;
    man.enable = true;
    dev.enable = false;
  };

  services.logind = {
    powerKey = "suspend";
    lidSwitch = "suspend-then-hibernate";
  };

  # OpenGL
  hardware = {
    bluetooth.enable = true;
    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
      extraPackages = with nixpkgs; [
        # amdvlk
        rocmPackages.clr.icd
        rocmPackages.clr
      ];
      # extraPackages32 = with pkgs; [driversi686Linux.amdvlk];
    };
  };

  networking = {
    hostName = "sforza";
    useDHCP = false;
    defaultGateway = {
      address = "192.168.1.1";
      interface = "wlp4s0";
    };
    interfaces.enp3s0.useDHCP = true; # will override networking.useDHCP
    interfaces.wlp4s0 = {
      ipv4.addresses = [
        {
          address = "192.168.1.99";
          prefixLength = 24;
        }
      ];
    };
    networkmanager.enable = true;

    wg-quick.interfaces = {
      wg0 = {
        autostart = true;
        address = [ "10.66.66.2/32" ];
        dns = [ "45.76.145.144" ];
        privateKeyFile = "/persist/wireguard/privateKey";

        peers = [
          {
            publicKey = "hOxW74kF//JpljARxf4+lu+cbwgn8OtB+lXT2Tqoyhk=";
            presharedKeyFile = "/persist/wireguard/presharedKey";
            allowedIPs = [ "0.0.0.0/0" ];
            endpoint = "45.76.145.144:51820";
            persistentKeepalive = 25;
          }
        ];
      };
    };
  };

  # TLP For Laptop
  services = {
    tlp = {
      enable = true;
      settings = {
        CPU_SCALING_GOVERNOR_ON_AC = "performance";
        CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

        CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
        CPU_ENERGY_PERF_POLICY_ON_AC = "performance";

        CPU_MIN_PERF_ON_AC = 0;
        CPU_MAX_PERF_ON_AC = 100;
        CPU_MIN_PERF_ON_BAT = 0;
        CPU_MAX_PERF_ON_BAT = 50;
      };
    };
  };

  # Hardware Config
  boot = {
    loader = {
      systemd-boot.enable = lib.mkForce false;
      systemd-boot.configurationLimit = 5;
      efi.canTouchEfiVariables = true;
      efi.efiSysMountPoint = "/boot";
    };

    lanzaboote = {
      enable = true;
      pkiBundle = "/etc/secureboot";
    };

    kernelPackages = lib.mkForce inputs.chaotic.packages.${nixpkgs.system}.linuxPackages_cachyos;

    initrd.availableKernelModules = [
      "nvme"
      "xhci_pci"
      "ahci"
      "usb_storage"
      "usbhid"
      "sd_mod"
    ];
    initrd.kernelModules = [
      "amdgpu"
      "bcachefs"
      "dm-snapshot"
    ];
    kernelModules = [ "kvm-amd" ];
    extraModulePackages = [ ];
    supportedFilesystems = [
      "bcachefs"
      "ntfs"
      "xfs"
    ];
  };

  fileSystems =
    let
      username = "airi";
      userHome = "/home/${username}";
    in
    {
      "${userHome}/Media" = {
        device = "/dev/disk/by-uuid/9f731a8a-1d76-4b74-ad60-cb2e245d4224";
        fsType = "bcachefs";
        options = [
          # Enable discard/TRIM support
          "discard"
          # foreground compression with zstd
          "compression=zstd"
          # background compression with zstd
          "background_compression=zstd"
        ];
      };

      # "${userHome}/WinE" = {
      #   device = "/dev/disk/by-label/WinE";
      #   fsType = "ntfs";
      #   options = [
      #     "uid=1000"
      #     "gid=100"
      #     "rw"
      #     "user"
      #     "exec"
      #     "umask=000"
      #     "nofail"
      #   ];
      # };

      "/" = {
        device = "none";
        fsType = "tmpfs";
        options = [
          "defaults"
          "size=2G"
          "mode=755"
        ];
      };

      "/boot" = {
        device = "/dev/disk/by-label/BOOT";
        fsType = "vfat";
      };

      "/nix" = {
        device = "/dev/disk/by-partlabel/Store";
        fsType = "bcachefs";
        options = [
          # Enable discard/TRIM support
          "discard"
          # foreground compression with zstd
          "compression=zstd"
          # background compression with zstd
          "background_compression=zstd"
        ];
      };

      "/home" = {
        device = "/dev/disk/by-partlabel/Home";
        fsType = "bcachefs";
        options = [
          # Enable discard/TRIM support
          "discard"
          # foreground compression with zstd
          "compression=zstd"
          # background compression with zstd
          "background_compression=zstd"
        ];
        neededForBoot = true;
      };

      "/persist" = {
        device = "/dev/disk/by-label/Persist";
        fsType = "xfs";
        neededForBoot = true;
      };

      "/etc/nixos" = {
        device = "/persist/etc/nixos";
        fsType = "none";
        options = [ "bind" ];
      };

      "/var/log" = {
        device = "/persist/var/log";
        fsType = "none";
        options = [ "bind" ];
      };
    };

  swapDevices = [ { device = "/dev/disk/by-label/Swap"; } ];

  # slows down boot time
  systemd.services.NetworkManager-wait-online.enable = false;

  nix.settings.max-jobs = lib.mkDefault 4;
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  # Persistence
  environment.persistence."/persist" = {
    hideMounts = true;
    directories =
      [
        "/etc/NetworkManager/system-connections"
        "/etc/nix"
        "/etc/secureboot"
        "/var/lib/bluetooth"
        "/var/lib/libvirt"
        "/var/lib/nixos"
        "/var/lib/pipewire"
        "/var/lib/systemd/coredump"
      ]
      # ++ lib.optionals config.mine.dnscrypt.enable [ "/var/lib/dnscrypt-proxy2" ]
      # ++ lib.optionals config.mine.greetd.enable [ "/var/cache/regreet" ]
      ++ lib.optionals config.virtualisation.docker.enable [ "/var/lib/docker" ]
      ++ lib.optionals config.services.jellyfin.enable [ "/var/lib/jellyfin" ];
    files = [ "/etc/machine-id" ];
  };

  systemd.tmpfiles.rules = [
    # https://www.freedesktop.org/software/systemd/man/tmpfiles.d.html
    "L /var/lib/NetworkManager/secret_key - - - - /persist/var/lib/NetworkManager/secret_key"
    "L /var/lib/NetworkManager/seen-bssids - - - - /persist/var/lib/NetworkManager/seen-bssids"
    "L /var/lib/NetworkManager/timestamps - - - - /persist/var/lib/NetworkManager/timestamps"
  ];
}
