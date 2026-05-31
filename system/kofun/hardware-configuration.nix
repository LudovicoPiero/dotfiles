{
  config,
  lib,
  modulesPath,
  ...
}:

{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];
  boot = {
    initrd = {
      availableKernelModules = [
        "nvme"
        "xhci_pci"
        "ahci"
        "usb_storage"
        "usbhid"
        "sd_mod"
      ];
      kernelModules = [ ];
    };

    kernelModules = [ "kvm-amd" ];
    extraModulePackages = [ ];
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/27cfca29-4aab-4ca3-8bf3-c9d0220194e3";
      fsType = "btrfs";
      options = [
        "noatime"
        "compress=zstd"
      ];
    };

    "/home" = {
      device = "/dev/disk/by-uuid/00c972bd-994c-4708-b5c3-9227a371998f";
      fsType = "btrfs";
      neededForBoot = true;
    };

    "/persist" = {
      device = "/dev/disk/by-uuid/d8b7c41e-511d-41d5-9f4c-fb62604dc5be";
      fsType = "btrfs";
      neededForBoot = true;
      options = [
        "noatime"
        "compress=zstd"
      ];
    };

    "/home/${config.mine.vars.username}/WinE" = {
      device = "/dev/disk/by-label/WinE";
      fsType = "ntfs";
      options = [
        "uid=1000"
        "gid=100"
        "rw"
        "user"
        "exec"
        "dmask=0022" # Directories: 755 (Owner: rwx, Others: r-x)
        "fmask=0133" # Files: 644 (Owner: rw-, Others: r--)
        "nofail"
      ];
    };

    "/home/${config.mine.vars.username}/Media" = {
      device = "/dev/disk/by-label/Media";
      fsType = "btrfs";
      options = [
        "noatime"
        "compress=zstd"
      ];
    };

    "/boot" = {
      device = "/dev/disk/by-uuid/2EA6-2D42";
      fsType = "vfat";
      options = [
        "fmask=0022"
        "dmask=0022"
      ];
    };
  };

  swapDevices = [
    { device = "/dev/disk/by-uuid/2a214916-115a-4dd1-b93b-45da736cb32c"; }
  ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
