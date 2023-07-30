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
    systemPackages = with pkgs; [
      # theme packages
      (catppuccin-gtk.override {
        accents = ["mauve"];
        size = "compact";
        variant = "mocha";
      })
      apple-cursor
      papirus-icon-theme
    ];
  };

  programs.regreet = {
    enable = false;
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
