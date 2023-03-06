{
  lib,
  config,
  pkgs,
  ...
}: {
  hardware.opengl.enable = true;

  environment.systemPackages = with pkgs; [
    git
    home-manager
  ];

  time.timeZone = config.vars.timezone;
}
