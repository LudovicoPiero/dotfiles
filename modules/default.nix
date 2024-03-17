{
  modulesPath,
  pkgs,
  inputs,
  lib,
  config,
  userName,
  ...
}:
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    inputs.nh.nixosModules.default
    inputs.nur.hmModules.nur
    inputs.nix-colors.homeManagerModules.default
    inputs.home-manager.nixosModules.home-manager

    ./core/dnscrypt
    ./core/stubby
    ./core/security
    ./core/users
    ./core/fonts
    ./core/gnome
    ./core/direnv
    # ./core/fish
    ./core/git
    ./core/gpg
    ./core/lazygit
    ./core/pass
    ./core/ssh

    ./editor/emacs
    ./editor/nvim

    ./graphical/chromium
    ./graphical/firefox
    ./graphical/games
    ./graphical/hyprland
    ./graphical/qemu
    ./graphical/sway
    ./graphical/wezterm
    ./graphical/desktop
    ./graphical/foot
    ./graphical/gammastep
    ./graphical/kitty
    ./graphical/services
    ./graphical/thunar
    ./graphical/xdg-portal
    ./graphical/discord
    ./graphical/fuzzel
    ./graphical/greetd
    ./graphical/mako
    ./graphical/spotify
    ./graphical/waybar
  ];

  nixpkgs.config.allowUnfree = true;
  time.timeZone = "Asia/Tokyo";
  programs.command-not-found.enable = false; # Not working without channel

  environment = {
    pathsToLink = [ "/share/fish" ];
    systemPackages = lib.attrValues rec {
      inherit (pkgs)
        teavpn2
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
        sbctl # For debugging and troubleshooting Secure boot.
        authy
        bat
        fzf
        mpv
        telegram-desktop
        thunderbird
        imv
        viewnior
        qbittorrent
        xdg-utils
        yazi

        pavucontrol
        git
        bottom
        jq
        moreutils
        neovim
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
        ;

      inherit (pkgs.libsForQt5) kleopatra; # Gui for GPG

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
      NIXOS_OZONE_WL = "0";
      NIXPKGS_ALLOW_UNFREE = "1";
      EDITOR = "nvim";
      VISUAL = "nvim";
      TERM = "screen-256color";
      BROWSER = "firefox";
      XCURSOR_SIZE = "24";
      DIRENV_LOG_FORMAT = "";
      QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
      # Fix for some Java AWT applications (e.g. Android Studio),
      # use this if they aren't displayed properly:
      "_JAVA_AWT_WM_NONREPARENTING" = "1";
      FLAKE = "${config.users.users.${userName}.home}/.config/nixos"; # For NH ( https://github.com/viperML/nh/ )
    };
  };

  programs = {
    dconf.enable = true;
  };

  security = {
    rtkit.enable = true;

    sudo = {
      enable = true;
      extraConfig = ''
        # rollback results in sudo lectures after each reboot
        Defaults lecture = never

        # Show asterisk when typing password
        Defaults pwfeedback
      '';
    };

    pam = {
      services.swaylock.text = "auth include login";
    };
  };

  services = {
    # Service that makes Out of Memory Killer more effective
    earlyoom.enable = true;
    dbus.packages = [ pkgs.gcr ];

    # Enable periodic SSD TRIM of mounted partitions in background
    fstrim.enable = true;

    pipewire = {
      enable = lib.mkForce true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      wireplumber.enable = true;
    };

    # Location for gammastep
    geoclue2 = {
      enable = true;
      appConfig.gammastep = {
        isAllowed = true;
        isSystem = false;
      };
    };
  };

  nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 3d --keep 3";
  };

  nix = {
    nixPath = [ "nixpkgs=flake:nixpkgs" ]; # https://ayats.org/blog/channels-to-flakes/

    package = inputs.nix-super.packages.${pkgs.system}.nix;

    settings = {
      # Prevent impurities in builds
      sandbox = true;

      experimental-features = [
        "auto-allocate-uids"
        "ca-derivations"
        # "configurable-impure-env"
        "flakes"
        "no-url-literals"
        "nix-command"
        "parse-toml-timestamps"
        "read-only-local-store"
        "recursive-nix"
      ];

      accept-flake-config = true;
      auto-optimise-store = true;
      keep-derivations = true;
      keep-outputs = true;

      # Whether to warn about dirty Git/Mercurial trees.
      warn-dirty = false;

      # Give root user and wheel group special Nix privileges.
      trusted-users = [
        "root"
        "@wheel"
      ];
      allowed-users = [ "@wheel" ];

      substituters = [
        # Lower priority value = higher priority
        "https://cache.nixos.org?priority=1"
        "https://cache.garnix.io?priority=30"
        "https://dotfiles-pkgs.cachix.org?priority=20"
        "https://sforza-config.cachix.org?priority=10"
        "https://nixpkgs-unfree.cachix.org"
        "https://numtide.cachix.org"
        "https://nyx.chaotic.cx/"
      ];

      trusted-public-keys = [
        "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
        "dotfiles-pkgs.cachix.org-1:0TnsAyYE0P2BXv9s7gqqCpkf2SNt4cXKPh/66enbwnk="
        "sforza-config.cachix.org-1:qQiEQ1JU25VqhRXi1Qr/kA8RT01pd7oeKHr5OORUolM="
        "nixpkgs-unfree.cachix.org-1:hqvoInulhbV4nJ9yJOEr+4wxhDV4xq2d1DK7S6Nj6rs="
        "numtide.cachix.org-1:2ps1kLBUWjxIneOy1Ik6cQjb41X0iXVXeHigGmycPPE="
        "nyx.chaotic.cx-1:HfnXSw4pj95iI/n17rIDy40agHj12WfF+Gqk6SonIT8="
        "chaotic-nyx.cachix.org-1:HfnXSw4pj95iI/n17rIDy40agHj12WfF+Gqk6SonIT8="
      ];
    };

    registry = {
      system.flake = inputs.nixpkgs;
      default.flake = inputs.nixpkgs;
      nixpkgs.flake = inputs.nixpkgs;
    };

    # Improve nix store disk usage
    # Disable this because i'm using nh.
    # gc = {
    #   automatic = true;
    #   options = "--delete-older-than 3d";
    # };
    optimise.automatic = true;
  };

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users.${userName} = {
    home.username = "${userName}";
    home.homeDirectory = "/home/${userName}";
    home.stateVersion = "23.11";

    programs.home-manager.enable = true;
    systemd.user.startServices = "sd-switch";

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
  };

  system.stateVersion = "23.11";
}
