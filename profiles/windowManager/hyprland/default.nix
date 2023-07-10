# This Config is Heavily Based on the Config of sioodmy
# https://github.com/sioodmy/dotfiles
# And ocrScript is from fufexan's dotfiles
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
  systemd.services = {
    seatd = {
      enable = true;
      description = "Seat Management Daemon";
      script = "${pkgs.seatd}/bin/seatd -g wheel";
      serviceConfig = {
        Type = "simple";
        Restart = "always";
        RestartSec = 1;
      };
      wantedBy = ["multi-user.target"];
    };
  };

  # Enable hyprland module
  programs.hyprland.enable = true;

  home-manager.users."${config.vars.username}" = {
    home.sessionVariables = {
      NIXOS_OZONE_WL = "1";
    };
    home.packages = with pkgs; [
      # Utils
      inputs.hyprland-contrib.packages.${pkgs.system}.grimblast
      grim
      slurp
    ];

    wayland.windowManager.hyprland = {
      enable = true;
      package = inputs.hyprland.packages.${pkgs.system}.default;
      systemdIntegration = true;
      extraConfig = import ./config.nix args;
      xwayland.hidpi = true;
    };

    # User Services
    systemd.user.services = {
      swaybg = mkService {
        Unit.Description = "Images Wallpaper Daemon";
        Service = {
          ExecStart = "${lib.getExe pkgs.swaybg} -i ${./Wallpaper/wallpaper.jpg}";
          Restart = "always";
        };
      };
      # mpvpaper = mkService {
      #   Unit.Description = "Video Wallpaper Daemon";
      #   Service = {
      #     ExecStart = "${lib.getExe pkgs.mpvpaper} -o \"no-audio --loop-playlist shuffle\" eDP-1 ${./Wallpaper/wallpaper.mp4}";
      #     Restart = "always";
      #   };
      # };
      wl-clip-persist = mkService {
        Unit.Description = "Keep Wayland clipboard even after programs close";
        Service = {
          ExecStart = "${lib.getExe pkgs.wl-clip-persist} --clipboard both";
          Restart = "on-failure";
        };
      };
    };
  };
}
