{ pkgs, username, config, lib, ... }:
let
  font = {
    name = "SF Pro Rounded";
    size = 11;
  };

  theme = {
    name = "WhiteSur-Dark";
    package = pkgs.whitesur-gtk-theme;
  };

  cursorTheme = {
    name = "macOS-BigSur";
    size = 24;
    package = pkgs.apple-cursor;
  };

  iconsTheme = {
    name = "WhiteSur";
    package = pkgs.whitesur-icon-theme;
  };

  catppuccin-qt = pkgs.fetchFromGitHub {
    owner = "catppuccin";
    repo = "qt5ct";
    rev = "89ee948e72386b816c7dad72099855fb0d46d41e";
    hash = "sha256-t/uyK0X7qt6qxrScmkTU2TvcVJH97hSQuF0yyvSO/qQ=";
  };
  catppuccin-kvantum = pkgs.fetchFromGitHub {
    owner = "catppuccin";
    repo = "Kvantum";
    rev = "d1e174c85311de9715aefc1eba4b8efd6b2730fc";
    hash = "sha256-IrHo8pnR3u90bq12m7FEXucUF79+iub3I9vgH5h86Lk=";
  };

  # Borrowed from fuf's dotfiles
  apply-hm-env = pkgs.writeShellScript "apply-hm-env" ''
    ${lib.optionalString (config.home.sessionPath != []) ''
      export PATH=${builtins.concatStringsSep ":" config.home.sessionPath}:$PATH
    ''}
    ${builtins.concatStringsSep "\n" (lib.mapAttrsToList (k: v: ''
        export ${k}=${toString v}
      '')
      config.home.sessionVariables)}
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
  home.packages = with pkgs; [ run-as-service apple-cursor ];

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
    platformTheme = "qtct";
  };

  xdg.configFile = {
    ### Kvantum
    "Kvantum/Catppuccin-Mocha-Pink".source = "${catppuccin-kvantum}/src/Catppuccin-Mocha-Pink";
    "Kvantum/kvantum.kvconfig".text = ''
      [General]
      theme=Catppuccin-Mocha-Pink
    '';

    ### QT5
    "qt5ct/colors/Catppuccin-Mocha.conf".source = "${catppuccin-qt}/themes/Catppuccin-Mocha.conf";
    "qt5ct/qt5ct.conf".text = ''
      [Appearance]
      color_scheme_path=/home/${username}/.config/qt5ct/colors/Catppuccin-Mocha.conf
      custom_palette=true
      standard_dialogs=gtk3
      style=kvantum

      [Fonts]
      fixed="SF Pro Rounded,10,-1,5,50,0,0,0,0,0,Regular"
      general="SF Pro Rounded,10,-1,5,50,0,0,0,0,0,Regular"

      [Interface]
      activate_item_on_single_click=1
      buttonbox_layout=0
      cursor_flash_time=1000
      dialog_buttons_have_icons=1
      double_click_interval=400
      gui_effects=@Invalid()
      keyboard_scheme=2
      menus_have_icons=true
      show_shortcuts_in_context_menus=true
      stylesheets=@Invalid()
      toolbutton_style=4
      underline_shortcut=1
      wheel_scroll_lines=3

      [SettingsWindow]
      geometry=@ByteArray(\x1\xd9\xd0\xcb\0\x3\0\0\0\0\x2\xac\0\0\0\x1\0\0\x5T\0\0\x2\xde\0\0\x2\xac\0\0\0\x1\0\0\x5T\0\0\x2\xde\0\0\0\0\0\0\0\0\x5V\0\0\x2\xac\0\0\0\x1\0\0\x5T\0\0\x2\xde)

      [Troubleshooting]
      force_raster_widgets=1
      ignored_applications=@Invalid()
    '';

    ### QT6
    "qt6ct/colors/Catppuccin-Mocha.conf".source = "${catppuccin-qt}/themes/Catppuccin-Mocha.conf";
    "qt6ct/qt6ct.conf".text = ''
      [Appearance]
      color_scheme_path=/home/${username}/.config/qt6ct/colors/Catppuccin-Mocha.conf
      custom_palette=true
      standard_dialogs=gtk3
      style=kvantum

      [Fonts]
      fixed="SF Pro Rounded,10,-1,5,500,0,0,0,0,0,0,0,0,0,0,1"
      general="SF Pro Rounded,10,-1,5,500,0,0,0,0,0,0,0,0,0,0,1"

      [Interface]
      activate_item_on_single_click=1
      buttonbox_layout=0
      cursor_flash_time=1000
      dialog_buttons_have_icons=1
      double_click_interval=400
      gui_effects=@Invalid()
      keyboard_scheme=2
      menus_have_icons=true
      show_shortcuts_in_context_menus=true
      stylesheets=@Invalid()
      toolbutton_style=4
      underline_shortcut=1
      wheel_scroll_lines=3

      [SettingsWindow]
      geometry=@ByteArray(\x1\xd9\xd0\xcb\0\x3\0\0\0\0\0\0\0\0\0\0\0\0\x5S\0\0\x2\xdd\0\0\0\0\0\0\0\0\0\0\x5S\0\0\x2\xdd\0\0\0\0\0\0\0\0\x5V\0\0\0\0\0\0\0\0\0\0\x5S\0\0\x2\xdd)

      [Troubleshooting]
      force_raster_widgets=1
      ignored_applications=@Invalid()
    '';
  };

  home.file.".icons/default/index.theme".text = ''
    [icon theme]
    Name=Default
    Comment=Default Cursor Theme
    Inherits=${cursorTheme.name}
  '';

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      # Use dconf-editor to get this settings.
      color-scheme = "prefer-dark";
      cursor-theme = cursorTheme.name;
      gtk-theme = theme.name;
      icon-theme = iconsTheme.name;
    };
  };
}
