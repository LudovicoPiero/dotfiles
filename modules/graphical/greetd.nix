{
  pkgs,
  config,
  lib,
  ...
}: {
  programs.regreet = {
    enable = true;
    settings = {
      GTK = {
        cursor_theme_name = "macOS-BigSur";
        font_name = "SF Pro Rounded 12";
        icon_theme_name = "WhiteSur";
        theme_name = "WhiteSur-Dark";
      };
    };
  };

  services.greetd = let
    user = "ludovico";
    regreet = "${lib.getExe config.programs.regreet.package}";

    sway-kiosk = command: "${pkgs.sway}/bin/sway --config ${pkgs.writeText "kiosk.config" ''
      output * bg #000000 solid_color
      exec dbus-update-activation-environment --systemd DISPLAY WAYLAND_DISPLAY SWAYSOCK

      # Just in case if greetd not working properly
      bindsym Mod4+Return exec ${lib.getExe pkgs.wezterm}
      exec "${command}; ${pkgs.sway}/bin/swaymsg exit"
    ''}";
  in {
    enable = true;
    vt = 7;
    settings = {
      default_session = {
        command = sway-kiosk "${regreet}";
        inherit user;
      };
    };
  };
}
