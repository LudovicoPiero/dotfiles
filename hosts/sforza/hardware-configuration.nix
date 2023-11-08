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

  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod" "bcache" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  boot = {
    kernelPackages = lib.mkForce inputs.chaotic.packages.${pkgs.system}.linuxPackages_cachyos;
    #kernelModules = ["kvm-amd"];
    supportedFilesystems = ["bcachefs" "ntfs"];
  };

  fileSystems = let
    username = "ludovico";
    userHome = "/home/${username}";
  in {
    "/" = {
      device = "/dev/disk/by-uuid/78ce32bd-36a6-4792-87bd-78179f8556c1";
      fsType = "bcachefs";
      options = [
        # foreground compression with zstd
        "compression=zstd"
        # background compression with zstd
        "background_compression=zstd"
      ];
    };

    "/boot" = {
      device = "/dev/disk/by-uuid/3AD1-3D42";
      fsType = "vfat";
    };

    "/home" = {
      device = "/dev/nvme0n1p4:/dev/sda1";
      fsType = "bcachefs";
    };

    #"${userHome}/WinE" = {
    #  device = "/dev/disk/by-uuid/01D95CE318FF5AE0";
    #  fsType = "ntfs";
    #  options = ["uid=1000" "gid=100" "rw" "user" "exec" "umask=000" "nofail"];
    #};
  };

  swapDevices = [
    {device = "/dev/disk/by-uuid/accd67d4-8eec-4244-8d65-11c2869e4ee0";}
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
