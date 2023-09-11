{
  inputs,
  pkgs,
  config,
  ...
}: {
  security = {
    pam = {
      services.greetd.gnupg.enable = true;
      services.greetd.enableGnomeKeyring = true;
      services.sddm.gnupg.enable = true;
      services.sddm.enableGnomeKeyring = true;
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
    xserver.displayManager.sessionPackages = [
      inputs.hyprland.packages.${pkgs.system}.default
      config.programs.sway.package
    ];
    geoclue2 = {
      enable = true;
      appConfig.gammastep = {
        isAllowed = true;
        isSystem = false;
      };
    };
  };

  programs.dconf.enable = true;
}
