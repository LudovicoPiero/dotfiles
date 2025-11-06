{
  config,
  lib,
  inputs',
  self',
  pkgs,
  ...
}:
let
  inherit (lib) mkOption types mkIf;
  cfg = config.mine.gnome;
in
{
  options.mine.gnome = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable gnome.";
    };
  };

  config = mkIf cfg.enable {
    hj.packages = [
      # Theming
      self'.packages.whitesur-gtk-theme
      pkgs.whitesur-icon-theme
      pkgs.phinger-cursors

      # Gnome Extensions
      pkgs.gnomeExtensions.dash-to-panel
      pkgs.gnomeExtensions.user-themes
      pkgs.gnomeExtensions.appindicator
      pkgs.gnomeExtensions.quick-lang-switch

      # Etc
      # Added here because core-apps include this
      pkgs.gnome-tweaks
      pkgs.gnome-system-monitor
    ];

    # Enable the X11 windowing system.
    services.xserver.enable = true;
    services.displayManager.gdm.enable = true;
    services.desktopManager.gnome.enable = true;
    services.udev.packages = [ pkgs.gnome-settings-daemon ];

    # To disable installing GNOME's suite of applications
    # and only be left with GNOME shell.
    services.gnome.core-apps.enable = false;
    services.gnome.core-developer-tools.enable = false;
    services.gnome.games.enable = false;

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
