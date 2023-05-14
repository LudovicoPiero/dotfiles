{lib, ...}: {
  # Configure LUKS
  # blkid --match-tag UUID --output value "$DISK-part2"
  boot.initrd.luks.devices."cryptroot".device = "/dev/disk/by-uuid/8a29d1a4-83c7-4a46-ad37-736cfdfd9e70";

  # Configure ZFS
  boot.supportedFilesystems = ["zfs"];
  networking.hostId = "d2ce8a60"; # head -c8 /etc/machine-id
  boot.zfs.devNodes = "/dev/vg/root";

  # Roll back to blank snapshot on boot
  boot.initrd.postDeviceCommands = lib.mkAfter ''
    zfs rollback -r tank/local/root@blank
  '';

  environment.persistence."/persist" = {
    hideMounts = false;
    directories = [
      "/var/log"
      "/var/lib/bluetooth"
      "/var/lib/libvirt"
      "/var/lib/nixos"
      "/var/lib/pipewire"
      "/var/lib/systemd/coredump"
      "/etc/NetworkManager/system-connections"
      "/etc/nixos"
      "/etc/nix"
      "/run/agenix.d"
    ];
    files = [
      "/etc/machine-id"
    ];
  };

  systemd.tmpfiles.rules = [
    "L /var/lib/NetworkManager/secret_key - - - - /persist/var/lib/NetworkManager/secret_key"
    "L /var/lib/NetworkManager/seen-bssids - - - - /persist/var/lib/NetworkManager/seen-bssids"
    "L /var/lib/NetworkManager/timestamps - - - - /persist/var/lib/NetworkManager/timestamps"
  ];
}
