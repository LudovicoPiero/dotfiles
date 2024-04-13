{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:
{
  systemd.user.startServices = "sd-switch";

  home = {
    packages = lib.attrValues rec {
      inherit (pkgs)
        authy
        bat
        fd
        fzf
        mpv
        imv
        viewnior
        qbittorrent
        xdg-utils
        yazi
        kitty
        element-desktop
        ;

      inherit (pkgs.libsForQt5) kleopatra; # Gui for GPG

      inherit (inputs.nixpkgs-master.legacyPackages.${pkgs.system}) thunderbird telegram-desktop vscodium;

      swaylock = pkgs.writeShellScriptBin "swaylock-script" ''
        ${lib.getExe pkgs.swaylock-effects} \
        --screenshots \
        --clock \
        --indicator \
        --indicator-radius 100 \
        --indicator-thickness 7 \
        --effect-blur 7x5 \
        --effect-vignette 0.5:0.5 \
        --ring-color bb00cc \
        --key-hl-color 880033 \
        --line-color 00000000 \
        --inside-color 00000088 \
        --separator-color 00000000 \
        --grace 0 \
        --fade-in 0.2 \
        --font 'Iosevka q SemiBold' \
        -f
      '';

      swayidle-script = pkgs.writeShellScriptBin "swayidle-script" ''
        ${lib.getExe pkgs.swayidle} -w \
        timeout 900 '${swaylock}/bin/swaylock-script' \
        before-sleep '${swaylock}/bin/swaylock-script' \
        lock '${swaylock}/bin/swaylock-script'
      '';

      # use OCR and copy to clipboard
      wl-ocr =
        let
          inherit (pkgs)
            grim
            libnotify
            slurp
            tesseract5
            wl-clipboard
            ;
          _ = lib.getExe;
        in
        pkgs.writeShellScriptBin "wl-ocr" ''
          ${_ grim} -g "$(${_ slurp})" -t ppm - | ${_ tesseract5} - - | ${wl-clipboard}/bin/wl-copy
          ${_ libnotify} "$(${wl-clipboard}/bin/wl-paste)"
        '';
    };

    sessionVariables = {
      NIXOS_OZONE_WL = "1";
      NIXPKGS_ALLOW_UNFREE = "1";
      EDITOR = "nvim";
      VISUAL = "nvim";
      TERM = "screen-256color";
      BROWSER = "firefox";
      XCURSOR_SIZE = "24";
      DIRENV_LOG_FORMAT = "";
      # Fix for some Java AWT applications (e.g. Android Studio),
      # use this if they aren't displayed properly:
      "_JAVA_AWT_WM_NONREPARENTING" = "1";
      QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
      QT_QPA_PLATFORM = "wayland";
      SDL_VIDEODRIVER = "wayland";
      XDG_SESSION_TYPE = "wayland";
    };

    stateVersion = "23.11";
  };

  xdg =
    let
      browser = [ "firefox.desktop" ];
      chromium-browser = [ "chromium-browser.desktop" ];
      thunderbird = [ "thunderbird.desktop" ];

      # XDG MIME types
      associations = {
        "x-scheme-handler/chrome" = chromium-browser;
        "application/x-extension-htm" = browser;
        "application/x-extension-html" = browser;
        "application/x-extension-shtml" = browser;
        "application/x-extension-xht" = browser;
        "application/x-extension-xhtml" = browser;
        "application/xhtml+xml" = browser;
        "text/html" = browser;
        "x-scheme-handler/about" = browser;
        "x-scheme-handler/ftp" = browser;
        "x-scheme-handler/http" = browser;
        "x-scheme-handler/https" = browser;
        "x-scheme-handler/unknown" = browser;
        "inode/directory" = [ "thunar.desktop" ];

        "audio/*" = [ "mpv.desktop" ];
        "video/*" = [ "mpv.dekstop" ];
        "video/mp4" = [ "umpv.dekstop" ];
        "image/*" = [ "imv.desktop" ];
        "image/jpeg" = [ "imv.desktop" ];
        "image/png" = [ "imv.desktop" ];
        "application/json" = browser;
        "application/pdf" = [ "org.pwmt.zathura.desktop" ];
        "x-scheme-handler/discord" = [ "vesktop.desktop" ];
        "x-scheme-handler/spotify" = [ "spotify.desktop" ];
        "x-scheme-handler/tg" = [ "org.telegram.desktop.desktop" ];
        "x-scheme-handler/mailto" = thunderbird;
        "message/rfc822" = thunderbird;
        "x-scheme-handler/mid" = thunderbird;
        "x-scheme-handler/mailspring" = [ "Mailspring.desktop" ];
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
