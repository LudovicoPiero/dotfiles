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
    ./hardware-configuration.nix
    ./mine.nix
  ];

  environment.systemPackages = [inputs.ludovico-nvim.packages.${pkgs.system}.default ];
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

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  programs.gnupg.agent = {
    enable = true;
    settings = {
      #TODO
      homedir = "/home/lewdo/.config/gnupg";
    };
  };

  networking.networkmanager.enable = true; # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = config.vars.timezone;

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;
  services.desktopManager.plasma6.enable = true;
  # Using Wayland (preferred)
  services.displayManager.sddm.settings.General.DisplayServer = "wayland";

  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };
}
