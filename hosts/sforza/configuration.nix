# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{
  config,
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    # Include the results of the hardware scan.
    inputs.chaotic.nixosModules.default
    ./hardware-configuration.nix
    ./mine.nix
  ];

  # Enable documentation for developers (includes man 3)
  documentation = {
    enable = true;
    man.generateCaches = true;
    dev.enable = true;
  };
  environment.systemPackages = [
    pkgs.man-pages
    pkgs.man-pages-posix
  ];

  services.tailscale.enable = true;
  services.tailscale.useRoutingFeatures = "client";
  systemd.user.services.tailscale-systray = {
    enable = true;
    description = "Official Tailscale systray application for Linux";
    after = [ "network.target" ];
    wantedBy = [ "default.target" ];
    serviceConfig = {
      Type = "simple";
      ExecStart = ''${pkgs.tailscale}/bin/tailscale systray'';
    };
  };
  boot = {
    loader = {
      # Use the systemd-boot EFI boot loader.
      systemd-boot.enable = true;
      systemd-boot.configurationLimit = 5;
      efi.canTouchEfiVariables = true;
    }; # Added manually

    # Use latest kernel.
    kernelPackages = pkgs.linuxPackages_cachyos-lto;
  };

  # Chaotic's stuff
  chaotic.nyx.cache.enable = false;

  networking.networkmanager.enable = true; # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = config.vars.timezone;
}
