{
  pkgs,
  lib,
  ...
}: [
  {
    command = "${pkgs.feh}/bin/feh --bg-fill $HOME/Pictures/tdark.png";
    always = true;
  }
  {
    command = "${pkgs.picom}/bin/picom --experimental-backend";
  }
  {
    command = "${pkgs.dunst}/bin/dunst";
  }
]
