{
  config,
  inputs,
  lib,
  ...
}:
{
  # Home-Manager Stuff
  home-manager = {
    backupFileExtension = "hm.bak";
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit inputs; };

    users.${config.vars.username} =
      { config, osConfig, ... }:
      {
        systemd.user.startServices = "sd-switch";
        home = {
          sessionVariables =
            {
              EDITOR = "nvim";
              VISUAL = "nvim";
              NIXPKGS_ALLOW_UNFREE = "1";

              # XDG Related Stuff
              XDG_CACHE_HOME = config.xdg.cacheHome;
              XDG_CONFIG_HOME = config.xdg.configHome;
              XDG_CONFIG_DIR = config.xdg.configHome;
              XDG_DATA_HOME = config.xdg.dataHome;
              XDG_STATE_HOME = config.xdg.stateHome;
              XDG_RUNTIME_DIR = "/run/user/${toString osConfig.users.users.airi.uid}";

              XDG_DESKTOP_DIR = config.xdg.userDirs.desktop;
              XDG_DOCUMENTS_DIR = config.xdg.userDirs.documents;
              XDG_DOWNLOAD_DIR = config.xdg.userDirs.download;
              XDG_MUSIC_DIR = config.xdg.userDirs.music;
              XDG_PICTURES_DIR = config.xdg.userDirs.pictures;
              XDG_PUBLICSHARE_DIR = config.xdg.userDirs.publicShare;
              XDG_TEMPLATES_DIR = config.xdg.userDirs.templates;
              XDG_VIDEOS_DIR = config.xdg.userDirs.videos;

              LESSHISTFILE = "/tmp/less-hist";
              PARALLEL_HOME = "${config.xdg.configHome}/parallel";
            }
            // lib.optionalAttrs osConfig.vars.withGui {
              NIXOS_OZONE_WL = "1";
              TERM = "xterm-256color";
              BROWSER = "firefox";
              # Fix for some Java AWT applications (e.g. Android Studio),
              # use this if they aren't displayed properly:
              "_JAVA_AWT_WM_NONREPARENTING" = "1";
              QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
              QT_QPA_PLATFORM = "wayland";
              SDL_VIDEODRIVER = "wayland";
              XDG_SESSION_TYPE = "wayland";
            };
        };

        programs = {
          direnv = {
            enable = true;
            nix-direnv.enable = true;
          };
        };

        xdg = {
          enable = true;

          mimeApps = {
            enable = true;
          };

          cacheHome = "${config.home.homeDirectory}/.cache";
          configHome = "${config.home.homeDirectory}/.config";
          dataHome = "${config.home.homeDirectory}/.local/share";
          stateHome = "${config.home.homeDirectory}/.local/state";
          userDirs = {
            enable = true;
            createDirectories = true;

            documents = "${config.home.homeDirectory}/Documents";
            download = "${config.home.homeDirectory}/Downloads";
            music = "${config.home.homeDirectory}/Music";
            pictures = "${config.home.homeDirectory}/Pictures";
            videos = "${config.home.homeDirectory}/Videos";
            desktop = "${config.home.homeDirectory}/Desktop";
            publicShare = "${config.home.homeDirectory}/Public";
            templates = "${config.home.homeDirectory}/Templates";

            extraConfig = {
              XDG_CODE_DIR = "${config.home.homeDirectory}/Code";
              XDG_GAMES_DIR = "${config.home.homeDirectory}/Games";
              XDG_SCREENSHOT_DIR = "${config.xdg.userDirs.pictures}/Screenshots";
              XDG_RECORD_DIR = "${config.xdg.userDirs.videos}/Record";
            };
          };
        };

        home.stateVersion = osConfig.vars.stateVersion;
      };
  };
}
