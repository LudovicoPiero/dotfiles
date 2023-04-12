{
  pkgs,
  lib,
  ...
}: {
  services.xserver.desktopManager.gnome.enable = true;
  # Systray
  environment.systemPackages = with pkgs; [
    gnome.gnome-tweaks
    gnomeExtensions.appindicator
  ];
  services.udev.packages = with pkgs; [gnome.gnome-settings-daemon];
  services.dbus.packages = with pkgs; [gnome2.GConf];

  services.power-profiles-daemon.enable = lib.mkForce false;
  hardware.pulseaudio.enable = lib.mkForce false;

  environment.gnome.excludePackages =
    (with pkgs; [
      gnome-photos
      gnome-tour
    ])
    ++ (with pkgs.gnome; [
      cheese # webcam tool
      gnome-music
      gnome-terminal
      gedit # text editor
      epiphany # web browser
      geary # email reader
      evince # document viewer
      gnome-characters
      totem # video player
      tali # poker game
      iagno # go game
      hitori # sudoku game
      atomix # puzzle game
    ]);
}
