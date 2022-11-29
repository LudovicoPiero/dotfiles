{pkgs, ...}: {
  sound.enable = true;
  hardware.pulseaudio.enable = false;

  security = {
    rtkit.enable = true;
    polkit.enable = true;
    pam.services.swaylock.text = "auth include login";
  };

  # make HM-managed GTK stuff work
  programs.dconf.enable = true;

  # Enable OpenGL
  hardware.opengl = {
    enable = true;
    extraPackages = with pkgs; [amdvlk];
    driSupport = true;
    driSupport32Bit = true; # For wine, etc.
  };

  services = {
    # needed for GNOME services outside of GNOME Desktop
    dbus.packages = [pkgs.gcr];
    udev.packages = with pkgs; [gnome.gnome-settings-daemon];

    # TLP For Laptop
    tlp.enable = true;
    tlp.settings = {
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

      # https://linrunner.de/en/tlp/docs/tlp-faq.html#battery
      # use "tlp fullcharge" to override temporarily
      START_CHARGE_THRESH_BAT0 = 85;
      STOP_CHARGE_THRESH_BAT0 = 90;
      START_CHARGE_THRESH_BAT1 = 85;
      STOP_CHARGE_THRESH_BAT1 = 90;
    };

    gnome.gnome-keyring.enable = true; # Keyring daemon

    xserver = {
      enable = true;
      layout = "us"; # Configure keymap
      displayManager.lightdm.enable = false;
    };

    # Pipewire
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      wireplumber.enable = true;
    };
  };
}
