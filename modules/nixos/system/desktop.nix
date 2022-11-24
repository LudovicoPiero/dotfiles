{pkgs, ...}: {
  sound.enable = true;
  hardware.pulseaudio.enable = false;

  security.rtkit.enable = true;
  security.polkit.enable = true;

  # make HM-managed GTK stuff work
  programs.dconf.enable = true;

  services = {
    # needed for GNOME services outside of GNOME Desktop
    dbus.packages = [pkgs.gcr];
    udev.packages = with pkgs; [gnome.gnome-settings-daemon];

    gnome.gnome-keyring.enable = true; # Keyring daemon

    xserver = {
      enable = false;
      layout = "us"; # Configure keymap
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
