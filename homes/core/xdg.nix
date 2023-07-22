{config, ...}: let
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
    "inode/directory" = ["thunar.desktop"];

    "audio/*" = ["mpv.desktop"];
    "video/*" = ["mpv.dekstop"];
    "image/*" = ["imv.desktop"];
    "application/json" = browser;
    "application/pdf" = ["org.pwmt.zathura.desktop.desktop"];
    "x-scheme-handler/discord" = ["WebCord.desktop"];
    "x-scheme-handler/spotify" = ["spotify.desktop"];
    "x-scheme-handler/tg" = ["telegramdesktop.desktop"];
    "x-scheme-handler/mailto" = mailspring;
    "message/rfc822" = mailspring;
    "x-scheme-handler/mid" = mailspring;
  };
in {
  xdg = {
    enable = true;
    cacheHome = config.home.homeDirectory + "/.cache";

    mimeApps = {
      enable = true;
      defaultApplications = associations;
    };

    userDirs = {
      enable = true;
      createDirectories = true;
      documents = "${config.home.homeDirectory}/Documents";
      download = "${config.home.homeDirectory}/Downloads";
      music = "${config.home.homeDirectory}/Music";
      pictures = "${config.home.homeDirectory}/Pictures";
      videos = "${config.home.homeDirectory}/Videos";
      desktop = "${config.home.homeDirectory}";
      extraConfig = {
        XDG_CODE_DIR = "${config.home.homeDirectory}/Code";
        XDG_GAMES_DIR = "${config.home.homeDirectory}/Games";
        XDG_SCREENSHOT_DIR = "${config.xdg.userDirs.pictures}/Screenshots";
        XDG_RECORD_DIR = "${config.xdg.userDirs.videos}/Record";
      };
    };
  };
}
