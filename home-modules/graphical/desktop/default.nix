{
  pkgs,
  username,
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
    package = inputs.self.packages.${pkgs.system}.whitesur-gtk-theme;
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
in
{
  colorScheme = inputs.nix-colors.colorSchemes.oxocarbon-dark;
  home.packages = with pkgs; [
    run-as-service
    apple-cursor
  ];

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
      bookmarks =
        let
          inherit username;
        in
        [
          "file:///home/${username}/Code"
          "file:///home/${username}/Media"
          "file:///home/${username}/Documents"
          "file:///home/${username}/Downloads"
          "file:///home/${username}/Games"
          "file:///home/${username}/Music"
          "file:///home/${username}/Pictures"
          "file:///home/${username}/Videos"
          "file:///home/${username}/WinE"
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
    platformTheme = "gtk3";
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
      gtk-theme = theme.name;
      icon-theme = iconsTheme.name;
    };
    "org/gnome/desktop/wm/preferences" = {
      button-layout = "close,minimize,maximize:icon";
    };
  };
}
