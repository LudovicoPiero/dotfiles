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
    package = inputs.ludovico-nixpkgs.packages.${pkgs.system}.whitesur-gtk-theme;
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
  imports = [ inputs.stylix.homeManagerModules.stylix ];

  stylix = {
    base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
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
    };

    cursor = {
      package = pkgs.apple-cursor;
      name = "macOS-BigSur";
      size = 24;
    };

    fonts = {
      serif = {
        package = inputs.ludovico-nixpkgs.packages.${pkgs.system}.iosevka-q;
        name = "Iosevka q";
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

  home.packages = [ run-as-service ];

  # User Services
  systemd.user.services = {
    swaybg = mkService {
      Unit.Description = "Swaybg Services";
      Service = {
        ExecStart = "${lib.getExe pkgs.swaybg} -m stretch -i ${inputs.self}/assets/anime-nix-wallpaper.png";
        Restart = "on-failure";
      };
    };
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

  qt = {
    enable = true;
    platformTheme.name = "gtk3";
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
