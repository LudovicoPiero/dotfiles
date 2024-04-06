{ pkgs, ... }:
{
  programs.steam = {
    enable = true;
    package = pkgs.steam;
  };

  /*
    Enable udev rules for Steam hardware such as the Steam Controller,
    other supported controllers and the HTC Vive
  */
  hardware.steam-hardware.enable = true;
}
