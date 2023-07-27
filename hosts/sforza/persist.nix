{lib, ...}: {
  # ZFS
  boot.supportedFilesystems = ["zfs" "ntfs"];
  networking.hostId = "a5d66b54";
  boot.zfs.devNodes = "/dev/vg/root";

  security.sudo.extraConfig = ''
    # rollback results in sudo lectures after each reboot
    Defaults lecture = never

    # Show asterisk when typing password
    Defaults pwfeedback
  '';

  # Rollback to snapshot on boot
  boot.initrd.postDeviceCommands = lib.mkAfter ''
    zfs rollback -r tank/local/root@blank
  '';

  # blkid --match-tag UUID --output value "$DISK-part2"
  boot.initrd.luks.devices."cryptroot".device = "/dev/disk/by-uuid/1fbedb73-6da0-41f3-9050-b932eb5bb2b1";

  environment.persistence."/persist" = {
    hideMounts = true;
    directories = [
      "/var/lib/bluetooth"
      "/var/lib/libvirt"
      "/var/lib/nixos"
      "/var/lib/pipewire"
      "/var/lib/systemd/coredump"
      "/etc/NetworkManager/system-connections"
      "/etc/nixos"
      "/etc/nix"
    ];
    files = [
      "/etc/machine-id"
    ];
  };

  systemd.tmpfiles.rules = [
    # https://www.freedesktop.org/software/systemd/man/tmpfiles.d.html
    "L /var/lib/NetworkManager/secret_key - - - - /persist/var/lib/NetworkManager/secret_key"
    "L /var/lib/NetworkManager/seen-bssids - - - - /persist/var/lib/NetworkManager/seen-bssids"
    "L /var/lib/NetworkManager/timestamps - - - - /persist/var/lib/NetworkManager/timestamps"
  ];
}
