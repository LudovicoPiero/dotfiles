# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).
{
  lib,
  config,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  myOptions = {
    dnscrypt2.enable = true;
    teavpn2.enable = false;
    spotify.enable = true;
    fish.enable = true;
    firefox.enable = true;
    floorp.enable = true;
    hyprland.enable = true;
    vars = {
      colorScheme = "everforest-dark-hard";
      withGui = true;
      email = "lewdovico@gnuweeb.org";
    };
  };

  hardware.bluetooth = {
    enable = true;
    settings = {
      General = {
        Experimental = true;
      };
    };
  };

  networking.hostName = "sforza"; # Define your hostname.
  networking.networkmanager.enable = true; # Easiest to use and most distros use this by default.

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = lib.mkForce "us";
    useXkbConfig = true; # use xkb.options in tty.
  };

  sops.secrets."asfIpcPassword" = {
    owner = config.systemd.services.archisteamfarm.serviceConfig.User;
  };
  services = {
    # Enable sound.
    pipewire = {
      enable = true;
      pulse.enable = true;
      wireplumber = {
        enable = true;
        extraConfig."wireplumber.profiles".main."monitor.libcamera" = "disabled";
      };
    };

    # ArchiSteamFarm
    archisteamfarm = {
      enable = true;

      package = inputs.ludovico-nixpkgs.packages.${pkgs.system}.ArchiSteamFarm;

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
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.libinput.enable = true;
}
