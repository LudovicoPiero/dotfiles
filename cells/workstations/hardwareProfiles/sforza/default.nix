{
  lib,
  config,
  inputs,
  pkgs,
  ...
}:
{
  imports = [
    inputs.impermanence.nixosModules.impermanence
    inputs.lanzaboote.nixosModules.lanzaboote
  ];

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

    kernelPackages = pkgs.linuxPackages_latest;

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
          "relatime"
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
