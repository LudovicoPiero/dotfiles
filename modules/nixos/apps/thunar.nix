{ pkgs, ... }: {
  environment.systemPackages = with pkgs;[
    udisks
    gnome.gvfs # for gvfs-mount
    xfce.tumbler # for thumbnails
  ];

  programs = {
    thunar = {
      enable = true;
      plugins = with pkgs.xfce; [ thunar-archive-plugin thunar-volman ];
    };
  };
}
