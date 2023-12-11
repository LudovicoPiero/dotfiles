{
  pkgs,
  lib,
  username,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ./persist.nix
  ];

  mine = {
    games = {
      gamemode.enable = true;
      lutris.enable = true;
      steam.enable = true;
    };
    gnome = {
      enable = true;
      keyring.enable = true;
    };
    dnscrypt.enable = true;
    fonts.enable = true;
    greetd.enable = true;
    security.enable = true;
    qemu.enable = true;
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

  networking = {
    hostName = "sforza";
    useDHCP = lib.mkForce true;
    networkmanager.enable = true;
  };

  # TLP For Laptop
  services = {
    tlp.enable = lib.mkForce true;
    tlp.settings = {
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
      RADEON_DPM_STATE_ON_AC = "performance";
      RADEON_DPM_STATE_ON_BAT = "balanced";
      NMI_WATCHDOG = "0";
    };

    jellyfin = {
      enable = true;
      user = username;
      openFirewall = true;
    };

    xserver = {
      layout = "us"; # Configure keymap
      libinput.enable = true;
    };
  };
}
