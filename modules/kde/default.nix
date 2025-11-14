{
  config,
  lib,
  self',
  pkgs,
  ...
}:
let
  inherit (lib) mkOption types mkIf;
  cfg = config.mine.kde;
in
{
  options.mine.kde = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable KDE Plasma.";
    };
  };

  config = mkIf cfg.enable {
    hj.packages = [
      # Theming
      self'.packages.whitesur-gtk-theme
      (pkgs.orchis-theme.override { tweaks = [ "macos" ]; })
      pkgs.whitesur-icon-theme
      pkgs.phinger-cursors
    ];

    # Enable the X11 windowing system.
    services.xserver.enable = false; # optional
    services.displayManager.sddm.enable = true;
    services.displayManager.sddm.wayland.enable = true;
    services.desktopManager.plasma6.enable = true;
    environment.plasma6.excludePackages = with pkgs.kdePackages; [
      ark # KDE archive manager (zip/rar/7z/tar)
      baloo-widgets # Baloo metadata panel in Dolphin
      dolphin # KDE file manager
      dolphin-plugins # Extra Dolphin features (git, service menus, etc.)
      elisa # KDE music player
      ffmpegthumbs # Video thumbnails in Dolphin
      gwenview # KDE image viewer
      kate # KDE text editor
      khelpcenter # KDE help viewer (rarely needed)
      konsole # KDE terminal emulator
      krdp # KDE Wayland RDP remote-desktop server
      ktexteditor # Backend library for Kate (sudo save support)
      kwin-x11 # KWin window manager for X11
      (lib.getBin qttools) # Expose qdbus in PATH
      okular # KDE document/PDF viewer
      plasma-workspace-wallpapers # Default KDE wallpapers
      spectacle # KDE screenshot tool
    ];

    services.pipewire = {
      enable = true;
      pulse.enable = true;
    };

    # Thunar
    programs.thunar.enable = true;
    programs.xfconf.enable = true;
    programs.thunar.plugins = with pkgs.xfce; [
      thunar-archive-plugin # Requires an Archive manager like file-roller, ark, etc
      thunar-volman
    ];
    services.gvfs.enable = true; # Mount, trash, and other functionalities
    services.tumbler.enable = true; # Thumbnail support for images
  };
}
