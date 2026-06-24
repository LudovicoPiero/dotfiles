{ config, ... }:

{
  imports = [
    ./chaotic.nix
    ./mine.nix
    ./hardware-configuration.nix
    ./impermanence.nix
  ];

  boot = {
    loader = {
      systemd-boot.enable = true;
      systemd-boot.configurationLimit = 10;
      efi.canTouchEfiVariables = true;
    };
  };

  networking.hostName = "unit-01";
  networking.networkmanager.enable = true;

  i18n.defaultLocale = "en_US.UTF-8";

  services = {
    xserver.enable = true;
    displayManager.ly.enable = true;
    pulseaudio.enable = false;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };

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
  sops.secrets."asfIpcPassword" = {
    owner = config.systemd.services.archisteamfarm.serviceConfig.User;
  };

  hardware.bluetooth.enable = true;
  security.rtkit.enable = true;

  system.stateVersion = "25.11";
}
