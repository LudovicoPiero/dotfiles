{
  pkgs,
  inputs,
  ...
}: {
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

  systemd = {
    user.services.polkit-gnome-authentication-agent-1 = {
      description = "polkit-gnome-authentication-agent-1";
      wants = ["graphical-session.target"];
      wantedBy = ["graphical-session.target"];
      after = ["graphical-session.target"];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };
  };

  services = {
    # needed for GNOME services outside of GNOME Desktop
    dbus.packages = [pkgs.gcr];
    udev.packages = with pkgs; [gnome.gnome-settings-daemon];

    gnome.gnome-keyring.enable = true; # Keyring daemon

    xserver = {
      enable = true;
      layout = "us"; # Configure keymap
      displayManager.lightdm.enable = false;
      displayManager.gdm.enable = true;
      displayManager.sessions = [
        {
          manage = "window";
          name = "home-manager";
          start = ''
            exec $HOME/.xsession-hm
          '';
        }
      ];
    };

    # add hyprland to display manager sessions
    xserver.displayManager.sessionPackages = [inputs.hyprland.packages.${pkgs.system}.default];

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
