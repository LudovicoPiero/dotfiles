{
  suites,
  profiles,
  config,
  ...
}: {
  imports = [
    profiles.security
    profiles.core.nixos
    profiles.core.users
  ];

  boot.loader.systemd-boot.enable = true;

  # Required, but will be overridden in the resulting installer ISO.
  fileSystems."/" = {device = "/dev/disk/by-label/nixos";};

  system.stateVersion = "${config.vars.stateVersion}";
}
