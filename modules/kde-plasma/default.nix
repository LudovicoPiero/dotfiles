{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;

  excludedPackages = with pkgs.kdePackages; [
    plasma-browser-integration # Integrates browser features (tabs, media control, etc.) with KDE Plasma
    konsole # KDE's powerful terminal emulator
    (lib.getBin qttools) # Exposes Qt tools like `qdbus` in the PATH
    ark # Archiving tool (supports zip, tar, rar, etc.)
    elisa # KDE's modern music player
    gwenview # KDE's default image viewer with basic editing
    okular # Versatile document viewer (PDF, EPUB, etc.)
    kate # Advanced text editor with syntax highlighting and plugins
    khelpcenter # Help/documentation browser for KDE applications
    dolphin # File manager for KDE, highly configurable
    baloo-widgets # Adds file metadata (Baloo) info to Dolphin views
    dolphin-plugins # Additional Dolphin features (e.g. Git, ISO mounting)
    spectacle # KDE's screenshot tool (supports rectangular region, window, etc.)
    ffmpegthumbs # Enables video thumbnails in Dolphin via FFmpeg
    krdp # KDE's native RDP server (remote desktop hosting)
    xwaylandvideobridge # Allows Wayland windows to be shared with X11 apps (e.g., OBS)
  ];

  cfg = config.myOptions.kde-plasma;
in
{
  options.myOptions.kde-plasma = {
    enable = mkEnableOption "kde-plasma";
  };

  config = mkIf cfg.enable {
    services.desktopManager.plasma6.enable = true;
    environment.plasma6.excludePackages = excludedPackages;
  };
}
