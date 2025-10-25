{
  config,
  lib,
  pkgs,
  ...
}:
{
  sops = {
    secrets."userPassword".neededForUsers = true;
    secrets."rootPassword".neededForUsers = true;
  };

  programs.fish.enable = true; # TODO: move it somewhere else
  users = {
    mutableUsers = false;
    users.root.hashedPasswordFile = config.sops.secrets."rootPassword".path;
    users.${config.vars.username} = {
      hashedPasswordFile = config.sops.secrets."userPassword".path;
      isNormalUser = true;
      shell = pkgs.fish; # TODO: move it somewhere else
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
