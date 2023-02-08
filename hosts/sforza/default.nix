{
  config,
  pkgs,
  suites,
  ...
}: {
  ### root password is empty by default ###
  imports =
    [./hardware-configuration.nix]
    ++ suites.desktop;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";

  networking.networkmanager.enable = true;

  time.timeZone = config.vars.timezone;

  services.xserver = {
    enable = true;
    displayManager.sddm.enable = true;
  };

  # Enable Hyprland Modules
  programs.hyprland.enable = true;

  system.stateVersion = "22.11";
}
