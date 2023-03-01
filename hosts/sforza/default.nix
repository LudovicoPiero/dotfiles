{
  config,
  pkgs,
  suites,
  inputs,
  ...
}: {
  imports =
    [
      ./hardware-configuration.nix
      ./persist.nix
    ]
    ++ suites.sway
    /*
    ++ suites.hyprland
    */
    ;

  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
    loader.systemd-boot.configurationLimit = 5;
    loader.efi.efiSysMountPoint = "/boot";
    kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackages;
    supportedFilesystems = ["zfs" "ntfs"];
  };

  hardware.bluetooth.enable = true;

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

  system.stateVersion = "${config.vars.stateVersion}";
}
