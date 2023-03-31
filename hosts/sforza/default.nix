{
  config,
  pkgs,
  suites,
  inputs,
  lib,
  ...
}: {
  imports =
    [
      ./hardware-configuration.nix
      ./persist.nix
    ]
    ++ suites.sway
    ++ suites.hyprland;

  boot = {
    loader.systemd-boot.enable = true;
    loader.systemd-boot.configurationLimit = 5;
    loader.efi.canTouchEfiVariables = true;
    loader.efi.efiSysMountPoint = "/boot";
    # kernelPackages = pkgs.linuxPackages_latest;
    kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackages;
    supportedFilesystems = ["ntfs"];
  };

  hardware.bluetooth.enable = true;

  networking.networkmanager.enable = true;

  time.timeZone = config.vars.timezone;

  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "en_AU.UTF-8";
      LC_IDENTIFICATION = "en_AU.UTF-8";
      LC_MEASUREMENT = "en_AU.UTF-8";
      LC_MONETARY = "en_AU.UTF-8";
      LC_NAME = "en_AU.UTF-8";
      LC_NUMERIC = "en_AU.UTF-8";
      LC_PAPER = "en_AU.UTF-8";
      LC_TELEPHONE = "en_AU.UTF-8";
      LC_TIME = "en_AU.UTF-8";
    };
  };

  # TLP For Laptop
  services = {
    tlp.enable = true;
    tlp.settings = {
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
      RADEON_DPM_STATE_ON_AC = "performance";
      RADEON_DPM_STATE_ON_BAT = "battery";

      # https://linrunner.de/en/tlp/docs/tlp-faq.html#battery
      # use "tlp fullcharge" to override temporarily
      START_CHARGE_THRESH_BAT0 = 85;
      STOP_CHARGE_THRESH_BAT0 = 90;
      START_CHARGE_THRESH_BAT1 = 85;
      STOP_CHARGE_THRESH_BAT1 = 90;
    };
  };

  # services.greetd = {
  #   enable = true;
  #   # package = pkgs.greetd.gtkgreet;
  #   vt = 1;
  #   settings = {
  #     default_session = {
  #       command = "${pkgs.cage}/bin/cage -s -- ${pkgs.greetd.gtkgreet}/bin/gtkgreet";
  #       user = "ludovico";
  #     };
  #   };
  # };

  environment.etc."greetd/environments".text = ''
    sway
    Hyprland
    fish
  '';

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
      gdm = {
        enable = true;
        wayland = true;
      };
      # sddm = {
      #   enable = true;
      #   theme = "multicolor-sddm-theme";
      # };
    };
  };

  # Remove Bloat
  documentation.nixos.enable = lib.mkForce false;
  system.stateVersion = "${config.vars.stateVersion}";
}
