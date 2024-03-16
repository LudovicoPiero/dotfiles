{
  config,
  lib,
  inputs,
  ...
}: {
  imports = [inputs.impermanence.nixosModules.impermanence];

  environment.persistence."/persist" = {
    hideMounts = true;
    directories =
      [
        "/etc/NetworkManager/system-connections"
        "/etc/nix"
        "/etc/secureboot"
        "/var/lib/bluetooth"
        "/var/lib/libvirt"
        "/var/lib/nixos"
        "/var/lib/pipewire"
        "/var/lib/systemd/coredump"
      ]
      ++ lib.optionals config.virtualisation.docker.enable ["/var/lib/docker"]
      # ++ lib.optionals config.mine.dnscrypt.enable [ "/var/lib/dnscrypt-proxy2" ]
      ++ lib.optionals config.services.jellyfin.enable ["/var/lib/jellyfin"]
      # ++ lib.optionals config.mine.greetd.enable [ "/var/cache/regreet" ]
      ;
    files = ["/etc/machine-id"];
  };

  systemd.tmpfiles.rules = [
    # https://www.freedesktop.org/software/systemd/man/tmpfiles.d.html
    "L /var/lib/NetworkManager/secret_key - - - - /persist/var/lib/NetworkManager/secret_key"
    "L /var/lib/NetworkManager/seen-bssids - - - - /persist/var/lib/NetworkManager/seen-bssids"
    "L /var/lib/NetworkManager/timestamps - - - - /persist/var/lib/NetworkManager/timestamps"
  ];
}
