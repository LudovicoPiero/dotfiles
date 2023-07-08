{
  pkgs,
  config,
  lib,
  ...
}: let
  browser = ["firefox.desktop"];
  mailspring = ["Mailspring.desktop"];

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
    "x-scheme-handler/chrome" = ["chromium-browser.desktop"];
    "x-scheme-handler/ftp" = browser;
    "x-scheme-handler/http" = browser;
    "x-scheme-handler/https" = browser;
    "x-scheme-handler/unknown" = browser;
    "x-scheme-handler/mailspring" = mailspring;

    "audio/*" = ["mpv.desktop"];
    "video/*" = ["mpv.dekstop"];
    "image/*" = ["imv.desktop"];
    "application/json" = browser;
    "application/pdf" = ["org.pwmt.zathura.desktop.desktop"];
    "x-scheme-handler/discord" = ["discordcanary.desktop"];
    "x-scheme-handler/spotify" = ["spotify.desktop"];
    "x-scheme-handler/tg" = ["telegramdesktop.desktop"];
    "x-scheme-handler/mailto" = mailspring;
    "message/rfc822" = mailspring;
    "x-scheme-handler/mid" = mailspring;
  };
in {
  xdg = {
    portal = {
      # wlr disabled because i'm using xdg-desktop-portal-hyprland
      wlr.enable = lib.mkForce false;
      enable = true;
      extraPortals = [pkgs.xdg-desktop-portal-gtk];
    };
  };
  home-manager.users."${config.vars.username}" = {
    xdg = {
      enable = true;
      cacheHome = config.vars.home + "/.cache";

      mimeApps = {
        enable = true;
        defaultApplications = associations;
      };

      userDirs = {
        enable = true;
        createDirectories = true;
        documents = "${config.vars.home}/${config.vars.documentsFolder}";
        download = "${config.vars.home}/${config.vars.downloadFolder}";
        music = "${config.vars.home}/${config.vars.musicFolder}";
        pictures = "${config.vars.home}/${config.vars.picturesFolder}";
        templates = "${config.vars.home}/${config.vars.repositoriesFolder}";
        videos = "${config.vars.home}/${config.vars.videosFolder}";
        desktop = "${config.vars.home}";
        publicShare = "${config.vars.home}";
        extraConfig = {
          XDG_SCREENSHOTS_DIR = config.vars.screenshotFolder;
          #XDG_RECORD_DIR = "${config.xdg.userDirs.videos}/Record";
          #XDG_GAMES_DIR = "${config.home.homeDirectory}/Games";
          #XDG_CODE_DIR = "${config.home.homeDirectory}/Code";
        };
      };
    };
  };
}
