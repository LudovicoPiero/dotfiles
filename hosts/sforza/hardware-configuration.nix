{
  config,
  pkgs,
  lib,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot = {
    initrd.availableKernelModules = ["nvme" "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod" "bcache"];
    kernelPackages = lib.mkForce pkgs.linuxPackages_testing_bcachefs;
    initrd.kernelModules = ["amdgpu" "dm-snapshot"];
    kernelModules = ["kvm-amd"];
    extraModulePackages = [];
    supportedFilesystems = ["bcachefs" "ntfs"];
  };

  fileSystems = let
    username = "ludovico";
    userHome = "/home/${username}";
  in {
    "/" = {
      device = "/dev/nvme0n1p3:/dev/sda1";
      fsType = "bcachefs";
    };

    "/boot" = {
      device = "/dev/disk/by-uuid/C908-2F13";
      fsType = "vfat";
    };

    "${userHome}/WinE" = {
      device = "/dev/disk/by-uuid/01D95CE318FF5AE0";
      fsType = "ntfs";
      options = ["uid=1000" "gid=100" "rw" "user" "exec" "umask=000" "nofail"];
    };
  };

  swapDevices = [
    {device = "/dev/disk/by-uuid/fff70114-e482-4f51-8624-f1a35705e737";}
  ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp3s0.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp4s0.useDHCP = lib.mkDefault true;

  nix.settings.max-jobs = lib.mkDefault 4;
  # High-DPI console
  console.font = lib.mkDefault "${pkgs.terminus_font}/share/consolefonts/ter-u18b.psf.gz";
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
