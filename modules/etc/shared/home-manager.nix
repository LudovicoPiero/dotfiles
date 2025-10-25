{
  config,
  inputs,
  lib,
  ...
}:
{
  imports = [
    inputs.home-manager.nixosModules.home-manager
    (lib.modules.mkAliasOptionModule [ "hm" ] [ "home-manager" "users" config.vars.username ])
  ];

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;

  hm =
    { config, osConfig, ... }:
    {
      home.stateVersion = osConfig.vars.stateVersion;
      home.sessionVariables = {
        EDITOR = "nvim";
        VISUAL = "nvim";
        NIXPKGS_ALLOW_UNFREE = "1";
        MANPAGER = "sh -c 'col -bx | bat -l man -p'";

        # XDG-related stuff
        XDG_CACHE_HOME = config.xdg.cacheHome;
        XDG_CONFIG_HOME = config.xdg.configHome;
        XDG_CONFIG_DIR = config.xdg.configHome;
        XDG_DATA_HOME = config.xdg.dataHome;
        XDG_STATE_HOME = config.xdg.stateHome;
        XDG_DESKTOP_DIR = config.xdg.userDirs.desktop;
        XDG_DOCUMENTS_DIR = config.xdg.userDirs.documents;
        XDG_DOWNLOAD_DIR = config.xdg.userDirs.download;
        XDG_MUSIC_DIR = config.xdg.userDirs.music;
        XDG_PICTURES_DIR = config.xdg.userDirs.pictures;
        XDG_PUBLICSHARE_DIR = config.xdg.userDirs.publicShare;
        XDG_TEMPLATES_DIR = config.xdg.userDirs.templates;
        XDG_VIDEOS_DIR = config.xdg.userDirs.videos;
      }
      // lib.optionalAttrs osConfig.vars.withGui {
        NIXOS_OZONE_WL = "1";
        TERM = "xterm-256color";
        BROWSER = "firefox";
        # Fix for some Java AWT applications (e.g., Android Studio),
        # use this if they aren't displayed properly:
        "_JAVA_AWT_WM_NONREPARENTING" = "1";
        QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
        QT_QPA_PLATFORM = "wayland";
        SDL_VIDEODRIVER = "wayland";
        XDG_SESSION_TYPE = "wayland";
      };

      xdg =
        let
          browser = [ "zen-beta.desktop" ];
          thunderbird = [ "thunderbird.desktop" ];
          thunar = [ "thunar.desktop" ];

          # XDG MIME types
          associations = {
            "application/x-extension-htm" = browser;
            "application/x-extension-html" = browser;
            "application/x-extension-shtml" = browser;
            "application/x-extension-xht" = browser;
            "application/x-extension-xhtml" = browser;
            "application/xhtml+xml" = browser;
            "text/html" = browser;
            "x-scheme-handler/about" = browser;
            "x-scheme-handler/chrome" = browser;
            "x-scheme-handler/ftp" = browser;
            "x-scheme-handler/http" = browser;
            "x-scheme-handler/https" = browser;
            "x-scheme-handler/unknown" = browser;
            "x-scheme-handler/mailspring" = thunderbird;

            "audio/*" = [ "mpv.desktop" ];
            "video/*" = [ "mpv.desktop" ];
            "image/*" = [ "imv.desktop" ];
            "application/json" = browser;
            "application/pdf" = [ "org.pwmt.zathura.desktop" ];
            "x-scheme-handler/discord" = [ "vesktop.desktop" ];
            "x-scheme-handler/spotify" = [ "spotify.desktop" ];
            "x-scheme-handler/tg" = [ "org.telegram.desktop.desktop" ]; # not a typo
            "x-scheme-handler/mailto" = thunderbird;
            "message/rfc822" = thunderbird;
            "x-scheme-handler/mid" = thunderbird;
            "x-scheme-handler/news" = thunderbird;
            "x-scheme-handler/nntp" = thunderbird;

            "application/zip" = thunar;
            "application/x-tar" = thunar;
            "application/x-xz" = thunar;
            "application/x-bzip2" = thunar;
            "application/x-gzip" = thunar;
            "application/x-7z-compressed" = thunar;
            "application/x-rar" = thunar;
            "application/x-iso9660-image" = thunar;
            "inode/directory" = thunar;
          };
        in
        {
          enable = true;
          cacheHome = config.home.homeDirectory + "/.cache";

          mimeApps = {
            enable = true;
            defaultApplications = associations;
          };

          userDirs = {
            enable = true;
            createDirectories = true;
            extraConfig = {
              XDG_SCREENSHOTS_DIR = "${config.xdg.userDirs.pictures}/Screenshots";
              XDG_RECORD_DIR = "${config.xdg.userDirs.videos}/Record";
              XDG_GAMES_DIR = "${config.home.homeDirectory}/Games";
              XDG_MISC_DIR = "${config.home.homeDirectory}/Code";
            };
          };
        };
    };
}
