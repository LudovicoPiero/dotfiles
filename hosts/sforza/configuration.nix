# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).
{ pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./mine.nix
  ];

  hm =
    { osConfig, ... }:
    {
      services.tailscale-systray.enable = osConfig.services.tailscale.enable;
    };
  services.tailscale.enable = true;
  services.tailscale.useRoutingFeatures = "client";

  networking.hostName = "sforza"; # Define your hostname.
  networking.networkmanager.enable = true; # Easiest to use and most distros use this by default.

  # Use the systemd-boot EFI boot loader.
  boot = {
    loader = {
      systemd-boot.enable = true;
      systemd-boot.configurationLimit = 5;
      efi.canTouchEfiVariables = true;
      efi.efiSysMountPoint = "/boot";
    };

    initrd = {
      availableKernelModules = [
        "nvme"
        "xhci_pci"
        "ahci"
        "usbhid"
        "usb_storage"
        "sd_mod"
      ];
      kernelModules = [
        "amdgpu"
        "btrfs"
        "dm-snapshot"
      ];
    };

    kernelModules = [ "kvm-amd" ];
    extraModulePackages = [ ];
    supportedFilesystems = [
      "btrfs"
      "ntfs"
      "xfs"
    ];

    kernelPackages = pkgs.linuxPackages_latest;
  };
}
