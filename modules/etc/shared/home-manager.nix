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
    };
}
