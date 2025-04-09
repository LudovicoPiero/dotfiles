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
    orca
    evince
    # file-roller
    geary
    gnome-disk-utility
    # seahorse
    # sushi
    # sysprof
    #
    # gnome-shell-extensions
    #
    # adwaita-icon-theme
    # nixos-background-info
    # gnome-backgrounds
    # gnome-bluetooth
    # gnome-color-manager
    # gnome-control-center
    gnome-tour # GNOME Shell detects the .desktop file on first log-in.
    gnome-user-docs
    glib # for gsettings program
    # gnome-menus
    # gtk3.out # for gtk-launch program
    # xdg-user-dirs # Update user dirs as described in https://freedesktop.org/wiki/Software/xdg-user-dirs/
    # xdg-user-dirs-gtk # Used to create the default bookmarks
    #
    baobab
    epiphany
    gnome-text-editor
    gnome-calculator
    gnome-calendar
    gnome-characters
    gnome-clocks
    gnome-console
    gnome-contacts
    gnome-font-viewer
    gnome-logs
    gnome-maps
    gnome-music
    # gnome-system-monitor
    gnome-weather
    loupe # image viewer
    # nautilus
    gnome-connections
    simple-scan
    snapshot
    totem
    yelp
    gnome-software
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
      { config, osConfig, ... }:
      {
        dconf.settings = {
          "org/gnome/desktop/interface" = {
            # Use dconf-editor to get this settings.
            color-scheme = "prefer-dark";
            cursor-theme = config.gtk.cursorTheme.name;
            cursor-size = config.gtk.cursorTheme.size;
            gtk-theme = config.gtk.theme.name;
            icon-theme = config.gtk.iconTheme.name;
            font-name = "${osConfig.myOptions.theme.font.name} ${toString osConfig.myOptions.theme.font.size}";
            clock-format = "12h";
            clock-show-date = true;
            clock-show-seconds = false;
            clock-show-weekday = false;
            enable-animations = true;
            enable-hot-corners = false;
            font-antialiasing = "grayscale";
            font-hinting = "slight";
            scaling-factor = 1;
            text-scaling-factor = 1.0;
            toolbar-style = "text";
          };
          "org/gnome/desktop/background" = {
            color-shading-type = "solid";
            picture-options = "zoom";
            picture-uri = "${config.xdg.userDirs.pictures}/Wallpaper/Lain_Red.png";
            picture-uri-dark = "${config.xdg.userDirs.pictures}/Wallpaper/Lain_Red.png";
            primary-color = "#000000000000";
            secondary-color = "#000000000000";
          };
          "org/gnome/desktop/wm/preferences" = {
            button-layout = "close,minimize,maximize:";
            resize-with-right-button = true;
            mouse-button-modifier = "<super>";
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
