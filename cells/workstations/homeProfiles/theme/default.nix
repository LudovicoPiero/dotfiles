{
  pkgs,
  config,
  lib,
  inputs,
  ...
}:
let
  font = {
    name = "SF Pro Rounded";
    size = 11;
  };

  theme = {
    name = "WhiteSur-Dark";
    package = inputs.ludovico-nixpkgs.packages.${pkgs.system}.whitesur-gtk-theme;
  };

  cursorTheme = {
    name = "macOS-BigSur";
    size = 24;
    package = pkgs.apple-cursor;
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
  imports = [ inputs.nix-colors.homeManagerModules.default ];
  colorScheme = inputs.nix-colors.colorSchemes.dracula;
  home.packages = with pkgs; [
    run-as-service
    apple-cursor
  ];

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
      gtk-cursor-theme-name="${cursorTheme.name}"
      gtk-cursor-theme-size=${toString cursorTheme.size}
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
        gtk-cursor-theme-name = cursorTheme.name;
        gtk-cursor-theme-size = cursorTheme.size;
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
      inherit (font) name size;
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
    Inherits=${cursorTheme.name}

    [X-GNOME-Metatheme]
    GtkTheme=${theme.name}
    MetacityTheme=${theme.name}
    IconTheme=${iconsTheme.name}
    CursorTheme=${cursorTheme.name}
    ButtonLayout=close,minimize,maximize:menu
  '';

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      # Use dconf-editor to get this settings.
      color-scheme = "prefer-dark";
      cursor-theme = cursorTheme.name;
      cursor-size = cursorTheme.size;
      gtk-theme = theme.name;
      icon-theme = iconsTheme.name;
      font-name = "${font.name} ${toString font.size}";
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
