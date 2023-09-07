{pkgs, ...}: let
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
in {
  qt = {
    enable = true;
    platformTheme = "qtct";
  };

  ### TODO: Replace hardcoded path with substituteAll 
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
      color_scheme_path=/home/ludovico/.config/qt5ct/colors/Catppuccin-Mocha.conf
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
      color_scheme_path=/home/ludovico/.config/qt6ct/colors/Catppuccin-Mocha.conf
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
}
