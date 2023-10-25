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
    tuigreet = "${lib.getExe pkgs.greetd.tuigreet}";
    # sway-kiosk = command: "${pkgs.sway}/bin/sway --config ${pkgs.writeText "kiosk.config" ''
    #   output * bg #000000 solid_color
    #   exec ${pkgs.dbus}/bin/dbus-update-activation-environment  --systemd DISPLAY WAYLAND_DISPLAY SWAYSOCK
    #
    #   xwayland disable
    #
    #   # Just in case if greetd not working properly
    #   bindsym Mod4+Return exec ${lib.getExe pkgs.wezterm}
    #   exec "${command}; ${pkgs.sway}/bin/swaymsg exit"
    # ''}";
  in {
    enable = true;
    vt = 7;
    settings = {
      default_session = {
        # command = sway-kiosk "${tuigreet} --time --cmd Hyprland";
        command = lib.concatStringsSep " " [
          (lib.getExe pkgs.greetd.tuigreet)
          "--time"
          "--remember"
          "--remember-user-session"
          "--asterisks"
          # "--power-shutdown '${pkgs.systemd}/bin/systemctl shutdown'"
          "--cmd 'sway'"
        ];
        inherit user;
      };
    };
  };
}
