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

  boot = {
    kernelPackages = lib.mkForce inputs.chaotic.packages.${pkgs.system}.linuxPackages_cachyos;
    kernelParams = [
      "quiet"
    ];
    initrd.availableKernelModules = ["nvme" "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod"];
    initrd.kernelModules = ["dm-snapshot"];
    kernelModules = ["kvm-amd"];
    extraModulePackages = [];
    supportedFilesystems = ["bcachefs" "ntfs" "xfs"];
  };

  fileSystems = let
    username = "ludovico";
    userHome = "/home/${username}";
  in {
    "${userHome}/Media" = {
      device = "/dev/disk/by-uuid/7fe1c09f-a018-45e7-a7d7-bbc2958a30df";
      fsType = "xfs";
    };

    "${userHome}/WinE" = {
      device = "/dev/disk/by-uuid/01D95CE318FF5AE0";
      fsType = "ntfs";
      options = ["uid=1000" "gid=100" "rw" "user" "exec" "umask=000" "nofail"];
    };

    "/" = {
      device = "tank/local/root";
      fsType = "zfs";
    };

    "/boot" = {
      device = "/dev/disk/by-uuid/1253-75DB";
      fsType = "vfat";
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
      device = "tank/safe/persist";
      fsType = "zfs";
      neededForBoot = true;
    };
  };

  swapDevices = [
    {device = "/dev/disk/by-uuid/c186e5b4-bdba-46fd-8523-d484ebcb7108";}
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
  console.font = lib.mkDefault "${pkgs.terminus_font}/share/consolefonts/ter-u22b.psf.gz";
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
