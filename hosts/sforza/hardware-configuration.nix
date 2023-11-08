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
    nyx.cache.enable = false;
    nyx.overlay.enable = false;
  };

  boot.initrd.availableKernelModules = ["nvme" "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod"];
  boot.initrd.kernelModules = [];
  boot.kernelModules = ["kvm-amd"];
  boot.extraModulePackages = [];

  boot = {
    kernelPackages = lib.mkForce inputs.chaotic.packages.${pkgs.system}.linuxPackages_cachyos;
    #kernelModules = ["kvm-amd"];
    supportedFilesystems = ["bcachefs" "ntfs"];
  };

  boot.initrd.luks.devices."enc".device = "/dev/disk/by-uuid/3d92d49c-4003-4490-bea9-d8661d53af29";

  fileSystems = let
    username = "ludovico";
    userHome = "/home/${username}";
  in {
    "/" = {
      device = "/dev/disk/by-uuid/b1a16576-fc61-44cb-9abe-8c1f534c363f";
      fsType = "btrfs";
      options = ["subvol=root" "compress=zstd" "noatime"];
    };

    "/boot" = {
      device = "/dev/disk/by-uuid/9466-2507";
      fsType = "vfat";
    };

    "/nix" = {
      device = "/dev/disk/by-uuid/b1a16576-fc61-44cb-9abe-8c1f534c363f";
      fsType = "btrfs";
      options = ["subvol=nix"];
    };

    "/persist" = {
      device = "/dev/disk/by-uuid/b1a16576-fc61-44cb-9abe-8c1f534c363f";
      fsType = "btrfs";
      neededForBoot = true;
      options = ["subvol=persist" "compress=zstd" "noatime"];
    };

    "/var/log" = {
      device = "/dev/disk/by-uuid/b1a16576-fc61-44cb-9abe-8c1f534c363f";
      fsType = "btrfs";
      neededForBoot = true;
      options = ["subvol=log" "compress=zstd" "noatime"];
    };

    "/home" = {
      device = "/dev/disk/by-uuid/b1a16576-fc61-44cb-9abe-8c1f534c363f";
      fsType = "btrfs";
      neededForBoot = true;
      options = ["subvol=home" "compress=zstd" "noatime"];
    };

    "/Media" = {
      device = "/dev/disk/by-uuid/d62efbea-9c4c-43e2-b13c-b3ec65741167";
      fsType = "btrfs";
    };

    "${userHome}/WinE" = {
      device = "/dev/disk/by-uuid/01D95CE318FF5AE0";
      fsType = "ntfs";
      options = ["uid=1000" "gid=100" "rw" "user" "exec" "umask=000" "nofail"];
    };
  };

  swapDevices = [
    {device = "/dev/disk/by-uuid/75691d44-7af8-4bb9-b256-288764e79d7a";}
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
