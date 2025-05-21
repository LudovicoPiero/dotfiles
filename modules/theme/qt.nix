{ pkgs, config, ... }:
let
  catppuccin-mocha-blue = pkgs.catppuccin-kvantum.override {
    accent = "blue";
    variant = "mocha";
  };

  fontConfig = "${config.mine.fonts.main.name},${toString config.mine.fonts.size},-1,5,400,0,0,0,0,0,0,0,0,0,0,1";
in
{
  qt = {
    enable = true;
    platformTheme = "qt5ct";
    style = "kvantum";
  };

  hj.files = {
    ".config/Kvantum/catppuccin-mocha-blue".source =
      "${catppuccin-mocha-blue}/share/Kvantum/catppuccin-mocha-blue";
    ".config/Kvantum/kvantum.kvconfig".text = ''
      [General]
      theme=catppuccin-mocha-blue
    '';
    ".config/qt6ct/qt6ct.conf".text = ''
      [Appearance]
      icon_theme=${config.mine.theme.gtk.iconTheme.name}
      style=kvantum
      standard_dialogs=xdgdesktopportal
      custom_palette=false

      [Fonts]
      fixed=${fontConfig}
      general=${fontConfig}
    '';
    ".config/qt5ct/qt5ct.conf".text = ''
      [Appearance]
      icon_theme=${config.mine.theme.gtk.iconTheme.name}
      style=kvantum
      standard_dialogs=xdgdesktopportal
      custom_palette=false

      [Fonts]
      fixed=${fontConfig}
      general=${fontConfig}
    '';
  };
}
