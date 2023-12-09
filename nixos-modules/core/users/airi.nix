{ config
, pkgs
, lib
, username
, ...
}:
{
  programs.fish.enable = true;

  users.users."${username}" = {
    shell = pkgs.fish;
    initialPassword = "changeme";
    isNormalUser = true;
    uid = 1000;
    extraGroups =
      [
        "seat"
        "wheel"
      ]
      ++ lib.optional config.virtualisation.libvirtd.enable "libvirtd"
      ++ lib.optional config.virtualisation.docker.enable "docker"
      ++ lib.optional config.networking.networkmanager.enable "networkmanager"
      ++ lib.optional config.programs.light.enable "video";
  };
}
