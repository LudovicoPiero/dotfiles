{ config, pkgs, ... }:
{
  age.identityPaths = [ "${config.vars.home}/.ssh/id_ed25519" ];
  hardware.opengl.enable = true;

  environment.systemPackages = with pkgs; [
    git
    home-manager
  ];

  time.timeZone = config.vars.timezone;
}
