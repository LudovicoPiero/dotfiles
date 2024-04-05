{
  pkgs,
  lib,
  inputs,
  ...
}: let
  hyprlandPackage = "${lib.getExe inputs.hyprland.packages.${pkgs.system}.hyprland}";
  swayPackage = "${lib.getExe inputs.ludovico-nixpkgs.packages.${pkgs.system}.swayfx}";
  tuigreet = "${pkgs.greetd.tuigreet}/bin/tuigreet";
  username = "airi";
in {
  services.greetd = {
    enable = true;
    settings = {
      initial_session = {
        command = "${lib.getExe pkgs.sway}";
        user = "${username}";
      };
      default_session = {
        command = "${tuigreet} --greeting 'Welcome to NixOS!' --asterisks --remember --remember-user-session --time --cmd ${lib.getExe pkgs.sway}";
        user = "${username}";
      };
    };
  };
}
