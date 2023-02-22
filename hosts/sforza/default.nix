{
  config,
  pkgs,
  lib,
  suites,
  inputs,
  ...
}: {
  imports =
    [
      ./hardware-configuration.nix
      ./persist.nix
    ]
    ++ suites.desktop;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot";
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.supportedFilesystems = ["ntfs"];

  networking.networkmanager.enable = true;

  time.timeZone = config.vars.timezone;

  services.xserver = {
    enable = true;
    layout = "us"; # Configure keymap
    libinput.enable = true;
    deviceSection = ''
      Option "TearFree" "true"
    '';

    displayManager = {
      lightdm.enable = false;
      # Add Hyprland to display manager
      sessionPackages = [inputs.hyprland.packages.${pkgs.system}.default];
      # sddm = {
      #   enable = true;
      #   theme = "multicolor-sddm-theme";
      # };
    };
  };

  # Enable Hyprland Modules
  programs.hyprland.enable = true;

  system.stateVersion = "${config.vars.stateVersion}";
}
