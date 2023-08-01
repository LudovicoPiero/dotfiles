{
  lib,
  pkgs,
  inputs,
  ...
} @ args: let
  mkService = lib.recursiveUpdate {
    Unit.PartOf = ["graphical-session.target"];
    Unit.After = ["graphical-session.target"];
    Install.WantedBy = ["graphical-session.target"];
  };
in {
  home.packages = with pkgs; [
    # Utils
    inputs.hyprland-contrib.packages.${pkgs.system}.grimblast
    grim
    slurp
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.default;
    settings = import ./settings.nix args;
    xwayland.hidpi = true;
  };

  # User Services
  systemd.user.services = {
    wl-clip-persist = mkService {
      Unit.Description = "Keep Wayland clipboard even after programs close";
      Service = {
        ExecStart = "${lib.getExe pkgs.wl-clip-persist} --clipboard both";
        Restart = "on-failure";
      };
    };
  };
}
