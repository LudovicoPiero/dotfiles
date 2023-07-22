{
  config,
  pkgs,
  lib,
  ...
}: {
  boot = {
    initrd.availableKernelModules = ["nvme" "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod"];
    kernelPackages = pkgs.linuxPackages_xanmod_latest;
    # kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackages;
    initrd.kernelModules = ["dm-snapshot"];
    kernelModules = ["kvm-amd"];
    kernelParams = ["nohibernate" "zfs.zfs_arc_max=12884901888"];
    extraModulePackages = [];
    zfs.enableUnstable = true;
  };
  services.fstrim.enable = true;
  services.zfs = {
    autoScrub.enable = true;
    trim.enable = true;
  };

  fileSystems = let
    username = "ludovico";
    userHome = "/home/${username}";
  in {
    "/" = {
      device = "tank/local/root";
      fsType = "zfs";
    };

    "/boot" = {
      device = "/dev/disk/by-uuid/4FA8-A596";
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

    "${userHome}/WinE" = {
      device = "/dev/disk/by-uuid/01D95CE318FF5AE0";
      fsType = "ntfs";
      options = ["uid=1000" "gid=100" "rw" "user" "exec" "umask=000" "nofail"];
    };

    "${userHome}/WinD" = {
      device = "/dev/disk/by-uuid/01D95CDF9A689D70";
      fsType = "ntfs";
      options = ["uid=1000" "gid=100" "rw" "user" "exec" "umask=000" "nofail"];
    };

    "${userHome}/WinC" = {
      device = "/dev/disk/by-uuid/0454A86454A859E6";
      fsType = "ntfs";
      options = ["uid=1000" "gid=100" "rw" "user" "exec" "umask=000" "nofail"];
    };
  };

  swapDevices = [
    {device = "/dev/disk/by-uuid/2d66abab-93a2-4e86-897b-cbcdb7969c7a";}
  ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  # networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp3s0.useDHCP = lib.mkDefault true;
  networking.interfaces.wlp4s0.useDHCP = lib.mkDefault true;

  nix.settings.max-jobs = lib.mkDefault 4;
  # powerManagement.cpuFreqGovernor = lib.mkDefault "performance";
  # High-DPI console
  console.font = lib.mkDefault "${pkgs.terminus_font}/share/consolefonts/ter-u22n.psf.gz";
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
