{ config, lib, ... }:
{
  sops = {
    secrets."users/userPassword".neededForUsers = true;
    secrets."users/rootPassword".neededForUsers = true;
  };

  users = {
    mutableUsers = false;
    users.root.hashedPasswordFile = config.sops.secrets."users/rootPassword".path;
    users.${config.vars.username} = {
      uid = 1001;
      hashedPasswordFile = config.sops.secrets."users/userPassword".path;
      isNormalUser = true;
      extraGroups = [
        "seat"
        "video"
        "wheel"
      ]
      ++ lib.optional config.virtualisation.libvirtd.enable "libvirtd"
      ++ lib.optional config.virtualisation.docker.enable "docker"
      ++ lib.optional config.networking.networkmanager.enable "networkmanager";
    };
  };
}
