{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    (lutris.override {
      extraPkgs = pkgs: [
        pkgs.wineWowPackages.staging
        pkgs.pixman
        pkgs.libjpeg
        pkgs.zenity
      ];
    })
  ];
}
