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
      luks.devices."enc".device =
        "/dev/disk/by-uuid/4a5408ea-826a-41d4-a718-6a9fa9737067";
    };
    kernelModules = [ "kvm-amd" ];
    extraModulePackages = [ ];
  };

  fileSystems = {
    "/" = {
      device = "/dev/mapper/enc";
      fsType = "btrfs";
      options = [
        "subvol=root"
        "noatime"
        "compress=zstd"
      ];
    };

    "/home/rei/Media" = {
      device = "/dev/disk/by-uuid/42d72884-c5fb-43de-959b-3f475ec2cd1e";
      fsType = "btrfs";
      options = [
        "defaults"
        "compress=zstd"
        "noatime"
      ];
    };

    "/home/rei/WinE" = {
      device = "/dev/disk/by-uuid/5566A6764BCB04FF";
      fsType = "ntfs3";
      options = [
        "defaults"
        "uid=1000"
        "gid=100"
        "fmask=0022"
        "dmask=0022"
        "nofail"
      ];
    };

    "/home" = {
      device = "/dev/mapper/enc";
      fsType = "btrfs";
      options = [
        "subvol=home"
        "noatime"
        "compress=zstd"
      ];
    };

    "/nix" = {
      device = "/dev/mapper/enc";
      fsType = "btrfs";
      options = [
        "subvol=nix"
        "noatime"
        "compress=zstd"
      ];
    };

    "/persist" = {
      device = "/dev/mapper/enc";
      fsType = "btrfs";
      options = [
        "subvol=persist"
        "noatime"
        "compress=zstd"
      ];
      neededForBoot = true;
    };

    "/var/log" = {
      device = "/dev/mapper/enc";
      fsType = "btrfs";
      options = [
        "subvol=log"
        "noatime"
        "compress=zstd"
      ];
      neededForBoot = true;
    };

    "/boot" = {
      device = "/dev/disk/by-uuid/8C65-4129";
      fsType = "vfat";
      options = [
        "fmask=0022"
        "dmask=0022"
      ];
    };
  };

  swapDevices = [
    { device = "/dev/disk/by-uuid/ba301c11-24fc-4890-b539-3ccd8327eb9a"; }
  ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
