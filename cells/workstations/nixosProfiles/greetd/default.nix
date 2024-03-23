{pkgs, ...}: let
  hyprlandPackage = "${pkgs.hyprland}/bin/Hyprland";
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
        command = "${tuigreet} --greeting 'Welcome to NixOS!' --asterisks --remember --remember-user-session --time -cmd ${hyprlandPackage}";
        user = "greeter";
      };
    };
  };
}
