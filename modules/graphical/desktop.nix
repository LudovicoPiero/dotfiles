{
  inputs,
  pkgs,
  config,
  lib,
  ...
}: let
  homeManagerConfig = config.home-manager.users.ludovico;
in {
  security = {
    pam = {
      services.greetd.gnupg.enable = true;
      services.greetd.enableGnomeKeyring = true;
      # services.sddm.gnupg.enable = true;
      # services.sddm.enableGnomeKeyring = true;
      services.swaylock.text = "auth include login";
    };
  };

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

  services = {
    xserver.displayManager.sessionPackages =
      # Useful for Display Manager like SDDM
      lib.optionals homeManagerConfig.wayland.windowManager.hyprland.enable [
        inputs.hyprland.packages.${pkgs.system}.default
      ]
      ++ lib.optionals homeManagerConfig.wayland.windowManager.sway.enable [
        pkgs.sway
      ];
    geoclue2 = {
      enable = true;
      appConfig.gammastep = {
        isAllowed = true;
        isSystem = false;
      };
    };
  };

  programs = {
    dconf.enable = true;
    hyprland = {
      enable = lib.mkIf homeManagerConfig.wayland.windowManager.hyprland.enable true;
      package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    };
  };
}
