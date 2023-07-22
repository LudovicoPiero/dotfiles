{
  # inputs,
  pkgs,
  lib,
  ...
}: {
  xdg = {
    portal = {
      # wlr disabled because i'm using xdg-desktop-portal-hyprland
      wlr.enable = lib.mkForce false;
      enable = true;
      extraPortals = lib.mkForce [
        pkgs.xdg-desktop-portal-gtk
        # (inputs.xdph.packages.${pkgs.system}.xdg-desktop-portal-hyprland.override {
        #   hyprland-share-picker = inputs.xdph.packages.${pkgs.system}.hyprland-share-picker.override {
        #     inherit (inputs.hyprland.packages.${pkgs.system}) hyprland;
        #   };
        # })
      ];
    };
  };
}
