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

    kernelPackages = inputs.chaotic-nyx.packages.${pkgs.system}.linuxPackages_cachyos;

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
      "zfs"
    ];

    zfs = {
      devNodes = "/dev/vg/root";
      package = inputs.chaotic-nyx.packages.${pkgs.system}.zfs_cachyos;
    };

    # blkid --match-tag UUID --output value "$DISK-part6"
    initrd.luks.devices."cryptroot".device = "/dev/disk/by-uuid/90743a6a-c41d-4cbb-ad8c-5258b9c82613";
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

      "${userHome}/WinE" = {
        device = "/dev/disk/by-label/WinE";
        fsType = "ntfs";
        options = [
          "uid=1000"
          "gid=100"
          "rw"
          "user"
          "exec"
          "umask=000"
          "nofail"
        ];
      };

      "/" = {
        device = "tank/local/root";
        fsType = "zfs";
      };

      "/boot" = {
        device = "/dev/disk/by-label/BOOT";
        fsType = "vfat";
        options = [
          "fmask=0022"
          "dmask=0022"
        ];
      };

      "/nix" = {
        device = "tank/local/nix";
        fsType = "zfs";
      };

      "/home" = {
        device = "tank/safe/home";
        fsType = "zfs";
        neededForBoot = true;
      };

      "/persist" = {
        device = "/dev/disk/by-label/Persist";
        fsType = "xfs";
        neededForBoot = true;
      };
    };

  swapDevices = [ { device = "/dev/disk/by-uuid/b67da05d-f9dd-4480-a76a-978feb5a5270"; } ];

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
      ++ lib.optionals config.programs.regreet.enable [
        "/var/empty/.cache"
        "/var/cache/regreet"
        "/var/log/regreet"
      ]
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
