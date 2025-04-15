{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    mkIf
    ;

  excludedPackages = with pkgs; [
    orca # Screen reader for visually impaired users
    evince # GNOME document viewer (supports PDF, PostScript, DjVu, etc.)
    geary # Lightweight email client for GNOME
    gnome-disk-utility # Manage disks, partitions, and S.M.A.R.T. data
    gnome-tour # GNOME Shell welcome tour (triggered on first login)
    gnome-user-docs # Official GNOME help and documentation
    glib # Provides `gsettings` CLI for GNOME settings management
    baobab # Disk usage analyzer with a graphical interface
    epiphany # GNOME's default web browser (aka GNOME Web)
    gnome-text-editor # Official modern text editor for GNOME
    gnome-calculator # Basic and scientific calculator
    gnome-calendar # Calendar app integrated with GNOME Online Accounts
    gnome-characters # Utility for inserting special characters and symbols
    gnome-clocks # World clocks, alarms, timers, and stopwatch
    gnome-console # Simple terminal emulator for GNOME (replaces gnome-terminal)
    gnome-contacts # Contact manager integrated with GNOME Online Accounts
    gnome-font-viewer # Tool to preview and install fonts
    gnome-logs # Viewer for system logs with a GUI
    gnome-maps # Map application using OpenStreetMap
    gnome-music # Music player designed for GNOME
    gnome-weather # Displays weather conditions and forecasts
    gnome-connections # Remote desktop and VNC client
    simple-scan # Scanning tool with a simple user interface
    snapshot # GNOME's webcam app for taking photos and videos
    totem # GNOME video player (also called "Videos")
    yelp # Help viewer for GNOME documentation
    gnome-software # GNOME software center (app installation and updates)
  ];

  cfg = config.myOptions.gnome;
in
{
  options.myOptions.gnome = {
    enable = mkEnableOption "gnome";
  };

  config = mkIf cfg.enable {
    services.xserver.desktopManager.gnome.enable = true;
    environment.gnome.excludePackages = excludedPackages;

    home-manager.users.${config.vars.username} =
      { config, ... }:
      {
        dconf.settings = {
          "org/gnome/desktop/background" = {
            color-shading-type = "solid";
            picture-options = "zoom";
            picture-uri = "${config.xdg.userDirs.pictures}/Wallpaper/Lain_Red.png";
            picture-uri-dark = "${config.xdg.userDirs.pictures}/Wallpaper/Lain_Red.png";
            primary-color = "#000000000000";
            secondary-color = "#000000000000";
          };

          # Gnome Extensions
          "org/gnome/shell" = {
            disable-user-extensions = false;
            enabled-extensions = with pkgs.gnomeExtensions; [
              appindicator.extensionUuid
              arcmenu.extensionUuid
              # blur-my-shell.extensionUuid
              caffeine.extensionUuid
              clipboard-indicator.extensionUuid
              dash-to-panel.extensionUuid
              kimpanel.extensionUuid
              system-monitor.extensionUuid
              user-themes.extensionUuid
            ];
          };
          "org/gnome/shell/extensions/blur-my-shell" = {
            brightness = 0.9;
          };
          "org/gnome/shell/extensions/blur-my-shell/panel" = {
            customize = true;
            sigma = 0;
          };
          "org/gnome/shell/extensions/blur-my-shell/overview" = {
            customize = true;
            sigma = 0;
          };
          "org/gnome/shell/extensions/caffeine" = {
            enable-fullscreen = true;
            restore-state = true;
            show-indicator = true;
            show-notification = false;
          };
          "org/gnome/shell/extensions/dash-to-dock" = {
            dash-max-icon-size = 32;
            icon-size-fixed = true;
          };
          "org/gnome/shell/extensions/dash-to-panel" = {
            animate-appicon-hover-animation-extent = "{'RIPPLE': 4, 'PLANK': 4, 'SIMPLE': 1}";
            hot-keys = true;
            panel-element-positions = "{\"SKY-0x01010101\":[{\"element\":\"showAppsButton\",\"visible\":false,\"position\":\"stackedTL\"},{\"element\":\"activitiesButton\",\"visible\":false,\"position\":\"stackedTL\"},{\"element\":\"leftBox\",\"visible\":true,\"position\":\"stackedTL\"},{\"element\":\"taskbar\",\"visible\":true,\"position\":\"stackedTL\"},{\"element\":\"centerBox\",\"visible\":true,\"position\":\"stackedBR\"},{\"element\":\"rightBox\",\"visible\":true,\"position\":\"stackedBR\"},{\"element\":\"dateMenu\",\"visible\":true,\"position\":\"stackedBR\"},{\"element\":\"systemMenu\",\"visible\":true,\"position\":\"stackedBR\"},{\"element\":\"desktopButton\",\"visible\":true,\"position\":\"stackedBR\"}]}";
            panel-sizes = "{\"SKY-0x01010101\":32}";
            show-tooltip = true;
            show-window-previews = false;
          };
          "org/gnome/shell/extensions/user-theme" = {
            name = "Default";
          };
        };

        home.packages = with pkgs.gnomeExtensions; [
          appindicator
          arcmenu
          # blur-my-shell
          caffeine
          clipboard-indicator
          dash-to-panel
          kimpanel
          system-monitor
          user-themes
        ];
      };
  };
}
