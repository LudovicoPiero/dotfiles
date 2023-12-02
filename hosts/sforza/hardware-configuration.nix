{
  config,
  pkgs,
  lib,
  modulesPath,
  inputs,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  chaotic = {
    mesa-git.enable = true;
    nyx.cache.enable = false;
    nyx.overlay.enable = true;
  };

  boot = {
    kernelPackages = lib.mkForce inputs.chaotic.packages.${pkgs.system}.linuxPackages_cachyos;
    kernelParams = [
      # "quiet"
    ];
    initrd.availableKernelModules = ["nvme" "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod"];
    initrd.kernelModules = ["amdgpu" "dm-snapshot"];
    kernelModules = ["kvm-amd"];
    extraModulePackages = [];
    supportedFilesystems = ["btrfs" "ntfs" "xfs"];
  };

  fileSystems = let
    username = "ludovico";
    userHome = "/home/${username}";
  in {
    "${userHome}/Media" = {
      device = "/dev/disk/by-label/Media";
      fsType = "xfs";
    };

    "${userHome}/WinE" = {
      device = "/dev/disk/by-label/WinE";
      fsType = "ntfs";
      options = ["uid=1000" "gid=100" "rw" "user" "exec" "umask=000" "nofail"];
    };

    "/" = {
      device = "none";
      fsType = "tmpfs";
      options = ["defaults" "size=2G" "mode=755"];
    };

    "/boot" = {
      device = "/dev/disk/by-label/BOOT";
      fsType = "vfat";
    };

    "/nix" = {
      device = "/dev/disk/by-label/store";
      fsType = "btrfs";
      options = ["autodefrag" "compress-force=zstd" "discard=async" "noatime" "space_cache=v2" "ssd"];
    };

    "/home" = {
      device = "/dev/disk/by-label/Home";
      fsType = "xfs";
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
      options = ["bind"];
    };

    "/var/log" = {
      device = "/persist/var/log";
      fsType = "none";
      options = ["bind"];
    };
  };

  swapDevices = [
    {device = "/dev/disk/by-label/Swap";}
  ];

  nix.settings.max-jobs = lib.mkDefault 4;
  # High-DPI console
  console.font = lib.mkDefault "${pkgs.terminus_font}/share/consolefonts/ter-u22b.psf.gz";
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
