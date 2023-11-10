{lib, ...}: {
  # Configure LUKS
  # blkid --match-tag UUID --output value "$DISK-part2"
  boot.initrd.luks.devices."cryptroot".device = "/dev/disk/by-uuid/aca877d2-a02d-47e4-a29c-51cca04e30ac";

  boot.supportedFilesystems = ["xfs" "ntfs" "zfs"];
  networking.hostId = "faf2f38e"; # head -c8 /etc/machine-id
  boot.zfs.devNodes = "/dev/vg/root";

  security.sudo.extraConfig = ''
    # rollback results in sudo lectures after each reboot
    Defaults lecture = never

    # Show asterisk when typing password
    Defaults pwfeedback
  '';

  # Roll back to blank snapshot on boot
  boot.initrd.postDeviceCommands = lib.mkAfter ''
    zfs rollback -r tank/local/root@blank
  '';

  services.zfs = {
    autoScrub = {
      enable = true;
      pools = ["tank"];
      interval = "weekly";
    };
  };

  environment.persistence."/persist" = {
    hideMounts = true;
    directories = [
      "/etc/NetworkManager/system-connections"
      "/etc/nixos"
      "/etc/nix"
      "/etc/secureboot"
      "/var/lib/bluetooth"
      "/var/lib/docker"
      "/var/lib/libvirt"
      "/var/lib/nixos"
      "/var/lib/pipewire"
      "/var/lib/systemd/coredump"
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
