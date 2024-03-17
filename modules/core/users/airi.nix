{
  config,
  pkgs,
  lib,
  userName,
  ...
}:
{
  programs.fish = {
    enable = true;
    shellInit = ''
      . /persist/github/stuff
    '';
  };

  users.users."${userName}" = {
    shell = pkgs.fish;
    hashedPasswordFile = "/persist/users/airi";
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
