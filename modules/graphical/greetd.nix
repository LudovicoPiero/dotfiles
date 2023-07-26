{
  pkgs,
  config,
  lib,
  ...
}: {
  environment.systemPackages = with pkgs; [
    # theme packages
    (catppuccin-gtk.override {
      accents = ["mauve"];
      size = "compact";
      variant = "mocha";
    })
    apple-cursor
    papirus-icon-theme
  ];

  programs.regreet = {
    enable = true;
    settings = {
      GTK = {
        cursor_theme_name = "macOS-BigSur";
        font_name = "SF Pro Rounded 12";
        icon_theme_name = "Papirus-Dark";
        theme_name = "Catppuccin-Mocha-Compact-Mauve-dark";
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
