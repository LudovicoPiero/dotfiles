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

  # My own modules
  mine = {
    games = {
      gamemode.enable = true;
      lutris.enable = true;
      steam.enable = true;
    };
    gnome = {
      enable = true;
      keyring.enable = true;
      nautilus.enable = true;
    };
    dnscrypt.enable = true;
    fonts.enable = true;
    greetd.enable = true;
    security.enable = true;
    qemu.enable = true;
  };

  services.logind = {
    powerKey = "suspend";
    lidSwitch = "suspend-then-hibernate";
  };

  # OpenGL
  environment.sessionVariables.AMD_VULKAN_ICD = lib.mkDefault "RADV";
  hardware = {
    bluetooth.enable = true;
    opengl = {
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
  };

  networking = {
    hostName = "sforza";
    useDHCP = lib.mkForce true;
    networkmanager.enable = true;
  };

  # TLP For Laptop
  services = {
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
