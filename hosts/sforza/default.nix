{
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ./persist.nix
  ];

  sops.secrets = {
    "wgPrivKey" = {
      mode = "0440";
    };
    "wgPreKey" = {
      mode = "0440";
    };
  };

  boot = {
    # Lanzaboote currently replaces the systemd-boot module.
    # This setting is usually set to true in configuration.nix
    # generated at installation time. So we force it to false
    # for now.
    loader = {
      systemd-boot.enable = lib.mkForce false;
      systemd-boot.configurationLimit = 5;
      efi.canTouchEfiVariables = true;
      efi.efiSysMountPoint = "/boot";
    };

    lanzaboote = {
      enable = true;
      pkiBundle = "/etc/secureboot";
    };
  };

  hardware.bluetooth.enable = true;

  # OpenGL
  environment.sessionVariables.AMD_VULKAN_ICD = lib.mkDefault "RADV";
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
    extraPackages = with pkgs; [
      # amdvlk
      rocmPackages.clr.icd
      rocmPackages.clr
    ];
    # extraPackages32 = with pkgs; [driversi686Linux.amdvlk];
  };

  time.timeZone = "Asia/Tokyo";

  networking = {
    hostName = "sforza";
    useDHCP = lib.mkForce true;
    nameservers = lib.mkForce [
      "1.1.1.1"
      "1.0.0.1"
    ];
    networkmanager.enable = true;
  };

  # TLP For Laptop
  services = {
    tlp.enable = lib.mkForce true;
    tlp.settings = {
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "schedutil";
      RADEON_DPM_STATE_ON_AC = "performance";
      RADEON_DPM_STATE_ON_BAT = "balanced";
      NMI_WATCHDOG = "0";
    };
  };

  services.xserver = {
    enable = true;
    layout = "us"; # Configure keymap
    libinput.enable = true;
    displayManager.lightdm.enable = false;
  };

  # networking.wg-quick.interfaces = {
  #   wg0 = {
  #     autostart = false;
  #     address = ["10.66.66.3/32" "fd42:42:42::3/128"];
  #     dns = ["1.1.1.1" "1.0.0.1"];
  #     privateKeyFile = config.sops.secrets.wgPrivKey.path;
  #
  #     peers = [
  #       {
  #         publicKey = "6c2tFt3lF9+/UiSuxwrKBypON0U2y7wYGn9DWEBmi2A=";
  #         presharedKeyFile = config.sops.secrets.wgPreKey.path;
  #         allowedIPs = ["0.0.0.0/0" "::/0"];
  #         endpoint = "103.235.73.71:50935";
  #         persistentKeepalive = 25;
  #       }
  #     ];
  #   };
  # };

  system.stateVersion = "23.11";
}
