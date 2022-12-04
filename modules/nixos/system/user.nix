{pkgs, ...}: {
  users.users.ludovico = {
    isNormalUser = true;
    description = "ludovico";
    extraGroups = ["storage" "input" "wheel" "video" "audio" "seat" "libvirtd" "networkmanager"];
    shell = pkgs.fish;
  };

  systemd = {
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
