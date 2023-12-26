{
  inputs,
  pkgs,
  config,
  lib,
  ...
}: {
  imports = [
    inputs.nur.hmModules.nur
    inputs.nix-colors.homeManagerModules.default

    ./core/git
    ./core/gpg
    ./core/direnv
    ./core/ssh
    ./core/fish

    ./editor/nvim
    ./editor/emacs

    ./graphical/desktop
    ./graphical/discord
    ./graphical/chromium
    ./graphical/firefox
    ./graphical/gammastep
    ./graphical/waybar
    ./graphical/mako
    ./graphical/fuzzel
    ./graphical/hyprland
    ./graphical/sway
    ./graphical/services
    ./graphical/spotify
    ./graphical/wezterm
  ];

  systemd.user.startServices = "sd-switch";

  home = {
    packages = lib.attrValues {
      inherit (inputs.chaotic.packages.${pkgs.system}) telegram-desktop_git;

      inherit
        (pkgs)
        authy
        fzf
        mpv
        thunderbird
        imv
        viewnior
        qbittorrent
        xdg-utils
        yazi
        ;

      inherit (pkgs.libsForQt5) kleopatra; # Gui for GPG

      # use OCR and copy to clipboard
      wl-ocr = let
        inherit (pkgs) grim libnotify slurp tesseract5 wl-clipboard;
        _ = lib.getExe;
      in
        pkgs.writeShellScriptBin "wl-ocr" ''
          ${_ grim} -g "$(${_ slurp})" -t ppm - | ${_ tesseract5} - - | ${wl-clipboard}/bin/wl-copy
          ${_ libnotify} "$(${wl-clipboard}/bin/wl-paste)"
        '';
    };
  };

  xdg = let
    browser = ["chromium-browser.desktop"];
    thunderbird = ["thunderbird.desktop"];

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
      "inode/directory" = ["org.gnome.Nautilus.desktop"];

      "audio/*" = ["mpv.desktop"];
      "video/*" = ["mpv.dekstop"];
      "image/*" = ["imv.desktop"];
      "application/json" = browser;
      "application/pdf" = ["org.pwmt.zathura.desktop"];
      "x-scheme-handler/discord" = ["vencorddesktop.desktop"];
      "x-scheme-handler/spotify" = ["spotify.desktop"];
      "x-scheme-handler/tg" = ["org.telegram.desktop.desktop"];
      "x-scheme-handler/mailto" = thunderbird;
      "message/rfc822" = thunderbird;
      "x-scheme-handler/mid" = thunderbird;
      "x-scheme-handler/mailspring" = ["Mailspring.desktop"];
    };
  in {
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
