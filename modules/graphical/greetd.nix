{
  pkgs,
  lib,
  inputs,
  ...
}: {
  environment = {
    etc."greetd/environments".text = ''
      river
      Hyprland
      sway
      fish
    '';
  };

  services.greetd = let
    user = "ludovico";
    sway = "${lib.getExe inputs.chaotic.packages.${pkgs.system}.sway_git}";
    swayConf = pkgs.writeText "greetd-sway-config" ''
      output * background #000000 solid_color
      exec "dbus-update-activation-environment --systemd WAYLAND_DISPLAY SWAYSOCK XDG_CURRENT_DESKTOP"
      xwayland disable

      exec "${pkgs.greetd.gtkgreet}/bin/gtkgreet -l; swaymsg exit"
    '';
  in {
    enable = true;
    vt = 7;
    settings = {
      default_session = {
        command = "${sway} --config ${swayConf}";
        inherit user;
      };
    };
  };
}
