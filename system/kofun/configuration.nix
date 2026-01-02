{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [ ./hardware-configuration.nix ];

  mine = {
    # WM / Compositor
    niri.enable = true;

    # Apps
    alacritty.enable = true;
    fish.enable = true;
    firefox.enable = true;
    git.enable = true;
    inputMethod = {
      enable = true;
      type = "fcitx5";

    };
    fonts.enable = true;
    gtk.enable = true;
    gpg.enable = true;
    mako.enable = true;
    rofi.enable = true;
    tmux.enable = true;
    waybar.enable = true;

    # Vars
    vars = {
      email = "lewdovico@gnuweeb.org";
      signingKey = "3911DD276CFE779C";
      withGui = true;
      isALaptop = true;
    };
  };

  boot = {
    loader = {
      systemd-boot.enable = true;
      systemd-boot.configurationLimit = 5;
      efi.canTouchEfiVariables = true;
    };

    # Use latest kernel for better hardware support
    kernelPackages = pkgs.linuxPackages_latest;
  };

  networking.hostName = "kofun";
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
  };

  hardware.bluetooth.enable = true;
  security.rtkit.enable = true;
  users.users.${config.mine.vars.username} = {
    isNormalUser = true;
    extraGroups = [
      "seat"
      "video"
      "wheel"
    ]
    ++ lib.optional config.virtualisation.libvirtd.enable "libvirtd"
    ++ lib.optional config.virtualisation.docker.enable "docker"
    ++ lib.optional config.networking.networkmanager.enable "networkmanager";
  };

  system.stateVersion = "25.11";
}
