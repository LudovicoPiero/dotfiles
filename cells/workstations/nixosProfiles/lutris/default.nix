{inputs}: let
  inherit (inputs) nixpkgs;
in {
  environment.systemPackages = with nixpkgs; [
    (lutris.override {
      extraPkgs = pkgs: [
        pkgs.wineWowPackages.staging
        pkgs.pixman
        pkgs.libjpeg
        pkgs.gnome.zenity
      ];
    })
  ];
}
