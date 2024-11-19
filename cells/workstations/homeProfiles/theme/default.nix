{
  pkgs,
  config,
  lib,
  inputs,
  ...
}:
let
  theme = {
    name = "WhiteSur-Dark";
    package = inputs.ludovico-nixpkgs.packages.${pkgs.stdenv.hostPlatform.system}.whitesur-gtk-theme;
  };

  iconsTheme = {
    name = "WhiteSur-dark";
    package = pkgs.whitesur-icon-theme;
  };

  # Borrowed from fuf's dotfiles
  apply-hm-env = pkgs.writeShellScript "apply-hm-env" ''
    ${lib.optionalString (config.home.sessionPath != [ ]) ''
      export PATH=${builtins.concatStringsSep ":" config.home.sessionPath}:$PATH
    ''}
    ${builtins.concatStringsSep "\n" (
      lib.mapAttrsToList (k: v: ''
        export ${k}=${toString v}
      '') config.home.sessionVariables
    )}
    ${config.home.sessionVariablesExtra}
    exec "$@"
  '';

  # runs processes as systemd transient services
  run-as-service = pkgs.writeShellScriptBin "run-as-service" ''
    exec ${pkgs.systemd}/bin/systemd-run \
      --slice=app-manual.slice \
      --property=ExitType=cgroup \
      --user \
      --wait \
      bash -lc "exec ${apply-hm-env} $@"
  '';

  mkService = lib.recursiveUpdate {
    Unit.PartOf = [
      "hyprland-session.target"
      "sway-session.target"
    ];
    Unit.After = [
      "hyprland-session.target"
      "sway-session.target"
    ];
    Install.WantedBy = [
      "hyprland-session.target"
      "sway-session.target"
    ];
  };
in
{
  imports = [
    inputs.stylix.homeManagerModules.stylix
    inputs.hyprcursor-phinger.homeManagerModules.hyprcursor-phinger
  ];

  home.packages = [
    run-as-service
    pkgs.qt6Packages.qtstyleplugin-kvantum
    pkgs.qt6Packages.qt6ct
    pkgs.libsForQt5.qtstyleplugin-kvantum
    pkgs.libsForQt5.qt5ct
  ];

  programs.hyprcursor-phinger.enable = true;
  stylix = {
    enable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/everforest-dark-hard.yaml";
    image = "${inputs.self}/assets/anime-nix-wallpaper.png";
    polarity = "dark";

    opacity =
      let
        opacityValue = 0.88;
      in
      {
        applications = opacityValue;
        desktop = opacityValue;
        popups = opacityValue;
        terminal = opacityValue;
      };

    targets = {
      firefox.enable = false;
      gtk.enable = false;
      gnome.enable = false;
      kde.enable = false;
      spicetify.enable = false;
    };

    cursor = {
      package = inputs.hyprcursor-phinger.packages.${pkgs.stdenv.hostPlatform.system}.default;
      name = "phinger-cursors-light";
      size = 24;
    };

    fonts = {
      serif = {
        package = inputs.ludovico-nixpkgs.packages.${pkgs.stdenv.hostPlatform.system}.iosevka-q;
        name = "Iosevka q Semibold";
      };
      sansSerif = config.stylix.fonts.serif;
      monospace = config.stylix.fonts.serif;

      emoji = {
        package = pkgs.noto-fonts-emoji;
        name = "Noto Color Emoji";
      };

      sizes = {
        applications = 12;
        desktop = 10;
        popups = 10;
        terminal = 14;
      };
    };
  };

  # User Services
  systemd.user.services = {
    wl-clip-persist = mkService {
      Unit.Description = "Keep Wayland clipboard even after programs close";
      Service = {
        ExecStart = "${lib.getExe pkgs.wl-clip-persist} --clipboard both";
        Restart = "on-failure";
      };
    };
  };

  gtk = {
    enable = true;

    gtk2.extraConfig = ''
      gtk-cursor-theme-name="${config.stylix.cursor.name}"
      gtk-cursor-theme-size=${toString config.stylix.cursor.size}
      gtk-toolbar-style=GTK_TOOLBAR_BOTH
      gtk-toolbar-icon-size=GTK_ICON_SIZE_LARGE_TOOLBAR
      gtk-button-images=1
      gtk-menu-images=1
      gtk-enable-event-sounds=1
      gtk-enable-input-feedback-sounds=1
      gtk-xft-antialias=1
      gtk-xft-hinting=1
      gtk-xft-hintstyle="hintfull"
      gtk-xft-rgba="rgb"
    '';

    gtk3 = {
      bookmarks = [
        "file:///home/${config.home.username}/Code"
        "file:///home/${config.home.username}/Media"
        "file:///home/${config.home.username}/Documents"
        "file:///home/${config.home.username}/Downloads"
        "file:///home/${config.home.username}/Games"
        "file:///home/${config.home.username}/Music"
        "file:///home/${config.home.username}/Pictures"
        "file:///home/${config.home.username}/Videos"
        "file:///home/${config.home.username}/WinE"
      ];

      extraConfig = {
        gtk-application-prefer-dark-theme = 1;
        gtk-cursor-theme-name = config.stylix.cursor.name;
        gtk-cursor-theme-size = config.stylix.cursor.size;
        gtk-toolbar-style = "GTK_TOOLBAR_BOTH";
        gtk-toolbar-icon-size = "GTK_ICON_SIZE_LARGE_TOOLBAR";
        gtk-button-images = 1;
        gtk-menu-images = 1;
        gtk-enable-event-sounds = 1;
        gtk-enable-input-feedback-sounds = 1;
        gtk-xft-antialias = 1;
        gtk-xft-hinting = 1;
        gtk-xft-hintstyle = "hintfull";
        gtk-xft-rgba = "rgb";
      };
    };

    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };

    font = {
      inherit (config.stylix.fonts.serif) name;
      size = config.stylix.fonts.sizes.desktop;
    };

    theme = {
      inherit (theme) name package;
    };

    iconTheme = {
      inherit (iconsTheme) name package;
    };
  };

  # QT
  qt = {
    enable = true;
    platformTheme = "qtct";
  };

  # Source: https://github.com/fufexan/dotfiles/blob/b946c18a1232e9529b28348a131faeb7f85668a3/home/programs/qt.nix#L38
  xdg.configFile =
    let
      defaultFont = "${config.gtk.font.name},${builtins.toString config.gtk.font.size}";
      KvLibadwaita = pkgs.fetchFromGitHub {
        owner = "GabePoel";
        repo = "KvLibadwaita";
        rev = "87c1ef9f44ec48855fd09ddab041007277e30e37";
        hash = "sha256-K/2FYOtX0RzwdcGyeurLXAh3j8ohxMrH2OWldqVoLwo=";
        sparseCheckout = [ "src" ];
      };

      qtctConf = {
        Appearance = {
          custom_palette = false;
          icon_theme = config.gtk.iconTheme.name;
          standard_dialogs = "xdgdesktopportal";
          style = "kvantum";
        };
      };
    in
    {
      # Kvantum config
      "Kvantum" = {
        source = "${KvLibadwaita}/src";
        recursive = true;
      };

      "Kvantum/kvantum.kvconfig".text = ''
        [General]
        theme=KvLibadwaitaDark
      '';

      # qtct config
      "qt5ct/qt5ct.conf".text =
        let
          default = ''"${defaultFont},-1,5,50,0,0,0,0,0"'';
        in
        lib.generators.toINI { } (
          qtctConf
          // {
            Fonts = {
              fixed = default;
              general = default;
            };
          }
        );

      "qt6ct/qt6ct.conf".text =
        let
          default = ''"${defaultFont},-1,5,400,0,0,0,0,0,0,0,0,0,0,1,Regular"'';
        in
        lib.generators.toINI { } (
          qtctConf
          // {
            Fonts = {
              fixed = default;
              general = default;
            };
          }
        );
    };

  home.file.".icons/default/index.theme".text = ''
    [icon theme]
    Name=Default
    Comment=Default Cursor Theme
    Inherits=${config.stylix.cursor.name}

    [X-GNOME-Metatheme]
    GtkTheme=${theme.name}
    MetacityTheme=${theme.name}
    IconTheme=${iconsTheme.name}
    CursorTheme=${config.stylix.cursor.name}
    ButtonLayout=close,minimize,maximize:menu
  '';

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      # Use dconf-editor to get this settings.
      color-scheme = "prefer-dark";
      cursor-theme = config.stylix.cursor.name;
      cursor-size = config.stylix.cursor.size;
      gtk-theme = theme.name;
      icon-theme = iconsTheme.name;
      font-name = "${config.stylix.fonts.serif.name} ${toString config.stylix.fonts.sizes.desktop}";
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
    "org/gnome/desktop/wm/preferences" = {
      button-layout = "close,minimize,maximize:icon";
    };
  };
}
