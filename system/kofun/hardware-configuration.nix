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
      device = "/dev/disk/by-uuid/a7a6f4c8-5269-472e-9cac-c98e56424953";
      fsType = "btrfs";
      options = [
        "noatime"
        "compress=zstd"
      ];
    };

    "/home" = {
      device = "/dev/disk/by-uuid/b79be9c9-3757-4415-a38d-faf9fe71acef";
      fsType = "xfs";
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
      device = "/dev/disk/by-uuid/E044-3FDE";
      fsType = "vfat";
      options = [
        "fmask=0022"
        "dmask=0022"
      ];
    };
  };

  swapDevices = [ ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
