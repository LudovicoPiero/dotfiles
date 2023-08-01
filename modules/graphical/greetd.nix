{
  pkgs,
  lib,
  ...
}: {
  environment = {
    etc."greetd/environments".text = ''
      Hyprland
      fish
    '';
  };

  services.greetd = let
    user = "ludovico";
    gtkgreet = "${lib.getExe pkgs.greetd.gtkgreet}";

    sway-kiosk = command: "${pkgs.sway}/bin/sway --config ${pkgs.writeText "kiosk.config" ''
      output * bg #000000 solid_color
      exec ${pkgs.dbus}/bin/dbus-update-activation-environment  --systemd DISPLAY WAYLAND_DISPLAY SWAYSOCK

      xwayland disable

      # Just in case if greetd not working properly
      bindsym Mod4+Return exec ${lib.getExe pkgs.wezterm}
      exec "${command}; ${pkgs.sway}/bin/swaymsg exit"
    ''}";
  in {
    enable = true;
    vt = 7;
    settings = {
      default_session = {
        command = sway-kiosk "${gtkgreet} -l -c 'Hyprland'";
        inherit user;
      };
    };
  };
}
