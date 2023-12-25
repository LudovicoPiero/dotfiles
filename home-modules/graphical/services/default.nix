{
  lib,
  pkgs,
  self,
  ...
}: let
  mkService = lib.recursiveUpdate {
    Unit.PartOf = ["hyprland-session.target" "sway-session.target"];
    Unit.After = ["hyprland-session.target" "sway-session.target"];
    Install.WantedBy = ["hyprland-session.target" "sway-session.target"];
  };
in {
  # User Services
  systemd.user.services = {
    swaybg = mkService {
      Unit.Description = "Swaybg Services";
      Service = {
        ExecStart = "${lib.getExe pkgs.swaybg} -m stretch -i ${self}/assets/Minato-Aqua-Dark.png";
        Restart = "on-failure";
      };
    };
    wl-clip-persist = mkService {
      Unit.Description = "Keep Wayland clipboard even after programs close";
      Service = {
        ExecStart = "${lib.getExe pkgs.wl-clip-persist} --clipboard both";
        Restart = "on-failure";
      };
    };
  };
}
