{pkgs, ...}: {
  users.users.ludovico = {
    isNormalUser = true;
    description = "ludovico";
    extraGroups = ["storage" "input" "wheel" "video" "audio" "seat" "libvirtd" "networkmanager"];
    shell = pkgs.zsh;
  };

  # Enable Gnome Polkit
  systemd = {
    # user.services.polkit-gnome-authentication-agent-1 = {
    #   description = "polkit-gnome-authentication-agent-1";
    #   wants = [ "graphical-session.target" ];
    #   wantedBy = [ "graphical-session.target" ];
    #   after = [ "graphical-session.target" ];
    #   serviceConfig = {
    #     Type = "simple";
    #     ExecStart =
    #       "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
    #     Restart = "on-failure";
    #     RestartSec = 1;
    #     TimeoutStopSec = 10;
    #   };
    # };

    # Enable Seatd here
    services = {
      seatd = {
        enable = true;
        description = "Seat management daemon";
        script = "${pkgs.seatd}/bin/seatd -g wheel";
        serviceConfig = {
          Type = "simple";
          Restart = "always";
          RestartSec = "1";
        };
        wantedBy = ["multi-user.target"];
      };
    };
  };
}
