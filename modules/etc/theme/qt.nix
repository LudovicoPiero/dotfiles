{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkOption types mkIf;
  cfg = config.mine.theme;
  fontcfg = config.mine.fonts;
  qtThemeCfg = config.mine.theme.qt;

  # Configuration for qt5ct and qt6ct
  qt5ctConf = pkgs.writeText "qt5ct.conf" ''
    [Appearance]
    color_scheme_path=
    custom_palette=false
    icon_theme=${cfg.gtk.iconTheme.name}
    standard_dialogs=default
    style=kvantum

    [Fonts]
    fixed="${fontcfg.main.name},${toString fontcfg.size}"
    general="${fontcfg.main.name},${toString fontcfg.size}"

    [Interface]
    activate_item_on_single_click=1
    buttonbox_layout=3
    cursor_flash_time=1000
    dialog_buttons_have_icons=1
    double_click_interval=400
    gui_effects=all
    menus_have_icons=true
    show_shortcuts_in_context_menus=true
    stylesheets_path=
    toolbutton_style=4
    underline_shortcut=1
    wheel_scroll_lines=3

    [Paths]
    custom_themes_path=~/.config/qt-themes

    [Troubleshooting]
    force_raster_widgets=
    force_right_to_left_layout=
  '';

  # Kvantum configuration to match the GTK theme
  kvantumConf = pkgs.writeText "kvantum.kvconfig" ''
    [General]
    theme=${cfg.gtk.theme.name}

    [Applications]
    use_custom_theme_for=
  '';
in
{
  options.mine.theme.qt = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable Qt theme configuration using Kvantum and qt5ct/qt6ct.";
    };
  };

  config = mkIf qtThemeCfg.enable {
    # Install necessary packages for Qt theming
    hj.packages = [
      pkgs.libsForQt5.qtstyleplugin-kvantum
      pkgs.libsForQt5.qt5ct
      pkgs.qt6Packages.qt6ct
    ];

    # Set environment variables to use qt5ct/qt6ct
    # Note: If you are using Home Manager, this should likely be `home.sessionVariables`
    environment.variables = {
      QT_QPA_PLATFORMTHEME = "qt5ct";
      QT_STYLE_OVERRIDE = "kvantum";
    };

    # Configure qt5ct, qt6ct, and Kvantum using hjem
    hj.files = {
      ".config/qt5ct/qt5ct.conf".source = qt5ctConf;
      ".config/qt6ct/qt6ct.conf".source = qt5ctConf; # Use the same config for qt6
      ".config/Kvantum/kvantum.kvconfig".source = kvantumConf;
      ".config/Kvantum/${cfg.gtk.theme.name}/${cfg.gtk.theme.name}.kvconfig".source =
        kvantumConf;
    };
  };
}
