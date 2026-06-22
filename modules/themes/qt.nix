{ pkgs, ... }: {
  hm = {
    qt = {
      enable = true;
      platformTheme.name = "kvantum";
      style.name = "kvantum";
    };

    home.packages = [
      pkgs.libsForQt5.qtstyleplugin-kvantum
      pkgs.whitesur-kde
    ];

    xdg.configFile."Kvantum/kvantum.kvconfig".text = ''
      [General]
      theme=WhiteSurDark
    '';
  };
}
