{
  lib,
  pkgs,
  config,
  inputs,
  ...
} @ args: let
  mkService = lib.recursiveUpdate {
    Unit.PartOf = ["hyprland-session.target"];
    Unit.After = ["hyprland-session.target"];
    Install.WantedBy = ["hyprland-session.target"];
  };
in {
  home.sessionVariables = {
    NIXOS_OZONE_WL = "1";
  };

  home.packages = with pkgs; [
    # Utils
    # inputs.hyprland-contrib.packages.${pkgs.system}.grimblast
    grim
    slurp
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.default;
    settings = import ./settings.nix args;
  };

  # User Services
  systemd.user.services = {
    swaybg = mkService {
      Unit.Description = "Images Wallpaper Daemon";
      Service = {
        ExecStart = "${lib.getExe pkgs.swaybg} -i ${./Wallpaper/hypr-chan.png}";
        Restart = "always";
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
