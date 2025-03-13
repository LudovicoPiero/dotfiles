{
  config,
  lib,
  pkgs,
  ...
}:
{
  # Home-Manager Stuff
  home-manager.backupFileExtension = "hm.bak";
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users.${config.myOptions.vars.username} =
    {
      config,
      osConfig,
      ...
    }:
    {
      systemd.user.startServices = "sd-switch";
      home = {
        sessionVariables =
          {
            EDITOR = "nvim";
            VISUAL = "nvim";
            NIXPKGS_ALLOW_UNFREE = "1";
          }
          // lib.optionalAttrs osConfig.myOptions.vars.withGui {
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

        packages = lib.attrValues {
          inherit (pkgs)
            teavpn2
            adwaita-icon-theme
            bat
            dosfstools
            gptfdisk
            iputils
            usbutils
            utillinux
            binutils
            coreutils
            curl
            direnv
            dnsutils
            fd
            fzf
            sbctl # For debugging and troubleshooting Secure boot.

            bottom
            jq
            moreutils
            nix-index
            nmap
            skim
            ripgrep
            tealdeer
            whois
            wl-clipboard
            wget
            unzip
            # Utils for nixpkgs stuff
            nixpkgs-review
            # Fav
            imv
            viewnior
            ente-auth
            thunderbird
            telegram-desktop
            mpv
            ;

          # use OCR and copy to clipboard
          wl-ocr =
            let
              _ = lib.getExe;
            in
            pkgs.writeShellScriptBin "wl-ocr" ''
              ${_ pkgs.grim} -g "$(${_ pkgs.slurp})" -t ppm - | ${_ pkgs.tesseract5} - - | ${pkgs.wl-clipboard}/bin/wl-copy
              ${_ pkgs.libnotify} "$(${pkgs.wl-clipboard}/bin/wl-paste)"
            '';
        };
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
            "x-scheme-handler/tonsite" = [ "org.telegram.desktop.desktop" ];
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

      home.stateVersion = osConfig.myOptions.vars.stateVersion;
    };
}
