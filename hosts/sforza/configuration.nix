# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).
{
  lib,
  config,
  pkgs,
  inputs,
  ...
}: let
  inherit (lib.generators) toLua;
in {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    inputs.lanzaboote.nixosModules.lanzaboote
  ];

  networking.hostName = "sforza"; # Define your hostname.
  networking.networkmanager.enable = true; # Easiest to use and most distros use this by default.

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

    kernelModules = ["kvm-amd"];
    extraModulePackages = [];
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
        PluginsUpdateList = ["ASFEnhance" "FreePackages"];
        PluginsUpdateMode = 0;
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

    #TODO: move tlp to modules/laptop or vars.isALaptop or something:))
    tlp = {
      enable = true;
      settings = {
        # conservative ondemand userspace powersave performance schedutil
        CPU_SCALING_GOVERNOR_ON_AC = "schedutil";
        CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

        # performance / balance_performance / default / balance_power / power
        CPU_ENERGY_PERF_POLICY_ON_AC = "balance_performance";
        CPU_ENERGY_PERF_POLICY_ON_BAT = "power";

        # 0 disable, 1 allow
        CPU_BOOST_ON_AC = 1;
        CPU_BOOST_ON_BAT = 0;

        # 0 disable, 1 enable
        CPU_HWP_DYN_BOOST_ON_AC = 1;
        CPU_HWP_DYN_BOOST_ON_BAT = 0;

        # 0 – off
        # 1..4 – maximum brightness reduction allowed by the ABM algorithm, 1 represents the least and 4 the most power saving
        AMDGPU_ABM_LEVEL_ON_AC = 0;
        AMDGPU_ABM_LEVEL_ON_BAT = 3;

        # performance / balanced / low-power
        PLATFORM_PROFILE_ON_AC = "balanced";
        PLATFORM_PROFILE_ON_BAT = "low-power";

        # auto – recommended / low / high
        RADEON_DPM_PERF_LEVEL_ON_AC = "auto";
        RADEON_DPM_PERF_LEVEL_ON_BAT = "low";

        /*
        auto – enabled (power down idle devices)
        on – disabled (devices powered on permanently)
        */
        RUNTIME_PM_ON_AC = "auto";
        RUNTIME_PM_ON_BAT = "auto";

        START_CHARGE_THRESH_BAT1 = "85";
        STOP_CHARGE_THRESH_BAT1 = "90";
      };
    };

    logind = {
      powerKey = "suspend";
      lidSwitch = "suspend-then-hibernate";
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
