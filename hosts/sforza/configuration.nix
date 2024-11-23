# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).
{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  myOptions = {
    fish.enable = true;
    firefox.enable = true;
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

  # Enable sound.
  services.pipewire = {
    enable = true;
    pulse.enable = true;
    wireplumber = {
      enable = true;
      extraConfig."wireplumber.profiles".main."monitor.libcamera" = "disabled";
    };
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.libinput.enable = true;
}
