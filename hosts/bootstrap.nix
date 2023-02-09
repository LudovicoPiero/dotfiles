{
  suites,
  profiles,
  ...
}: {
  imports = [
    suites.base
    # profiles.networking
    #profiles.core.nixos
    #profiles.core.users
  ];

  boot.loader.systemd-boot.enable = true;

  # Required, but will be overridden in the resulting installer ISO.
  fileSystems."/" = {device = "/dev/disk/by-label/nixos";};
}
