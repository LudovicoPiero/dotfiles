{
  pkgs,
  lib,
  inputs,
  ...
}: let
  hyprlandPackage = "${lib.getExe inputs.hyprland.packages.${pkgs.system}.hyprland}";
  tuigreet = "${pkgs.greetd.tuigreet}/bin/tuigreet";
  username = "airi";
in {
  services.greetd = {
    enable = true;
    settings = {
      initial_session = {
        command = "${hyprlandPackage}";
        user = "${username}";
      };
      default_session = {
        command = "${tuigreet} --greeting 'Welcome to NixOS!' --asterisks --remember --remember-user-session --time --cmd ${hyprlandPackage}";
        user = "${username}";
      };
    };
  };
}
