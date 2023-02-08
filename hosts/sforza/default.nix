{
  config,
  pkgs,
  suites,
  inputs,
  ...
}: {
  ### root password is empty by default ###
  imports =
    [./hardware-configuration.nix]
    ++ suites.desktop;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";
  boot.kernelPackages = pkgs.linuxPackages_xanmod_latest;

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
      sddm = {
        enable = true;
        theme = "multicolor-sddm-theme";
      };
    };
  };

  # Enable Hyprland Modules
  programs.hyprland.enable = true;

  system.stateVersion = "22.11";
}
