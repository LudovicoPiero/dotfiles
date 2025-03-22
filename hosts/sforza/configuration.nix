# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).
{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    inputs.lanzaboote.nixosModules.lanzaboote
  ];

  networking.hostName = "sforza"; # Define your hostname.
  networking.networkmanager = {
    enable = true; # Easiest to use and most distros use this by default.
    wifi.backend = "iwd";
  };

  # Use the systemd-boot EFI boot loader.
  boot = {
    loader = {
      # Lanzaboote currently replaces the systemd-boot module.
      # This setting is usually set to true in configuration.nix
      # generated at installation time. So we force it to false
      # for now.
      systemd-boot.enable = lib.mkForce false;
      systemd-boot.configurationLimit = 5;
      efi.canTouchEfiVariables = true;
      efi.efiSysMountPoint = "/boot";
    };

    # Secure Boot
    lanzaboote = {
      enable = true;
      pkiBundle = "/etc/secureboot";
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
        "bcachefs"
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

    kernelPackages = lib.mkForce pkgs.linuxPackages_cachyos-lto;
  };

  # OpenGL
  hardware = {
    bluetooth.enable = false;
    graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [
        rocmPackages.clr.icd
        rocmPackages.clr
      ];
    };
  };

  sops.secrets."asfIpcPassword" = {
    owner = config.systemd.services.archisteamfarm.serviceConfig.User;
  };
  services = {
    # ArchiSteamFarm
    archisteamfarm = {
      enable = true;

      settings = {
        Statistics = false;
        PluginsUpdateMode = 1;
        AutoClaimItemBotNames = "ASF";
        AutoClaimItemPeriod = 23;
      };

      ipcPasswordFile = config.sops.secrets."asfIpcPassword".path;
      ipcSettings = {
        Kestrel = {
          Endpoints = {
            HTTP = {
              Url = "http://*:1242";
            };
          };
        };
      };
    };
  };

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = lib.mkForce "us";
    useXkbConfig = true; # use xkb.options in tty.
  };
}
