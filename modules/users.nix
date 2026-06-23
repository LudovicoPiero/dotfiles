{ config, lib, ... }: {
  users.mutableUsers = false;
  users.users.root.hashedPasswordFile = "/persist/rootPassword";
  users.users.rei = {
    isNormalUser = true;
    hashedPasswordFile = "/persist/userPassword";
    extraGroups = [
      "seat"
      "video"
      "wheel"
    ]
    ++ lib.optional config.virtualisation.libvirtd.enable "libvirtd"
    ++ lib.optional config.virtualisation.docker.enable "docker"
    ++ lib.optional config.networking.networkmanager.enable "networkmanager";
  };
}
