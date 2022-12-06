{
  pkgs,
  lib,
  ...
}: {
  home.packages = with pkgs; [
    mpv
    ranger
  ];

  xdg.configFile."ranger/rc.conf".text = ''
    set preview_images true
    set preview_images_method kitty
  '';
}
