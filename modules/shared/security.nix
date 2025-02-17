{
  lib,
  config,
  ...
}:
{
  # sets hidepid=2 on /proc (make process info visible only to owning user)
  # NOTE Was removed on nixpkgs-unstable because it doesn't do anything
  # security.hideProcessInformation = true;
  # Prevent replacing the running kernel w/o reboot
  # security.protectKernelImage = true;

  boot = {
    # tmpfs = /tmp is mounted in ram. Doing so makes temp file management speedy
    # on ssd systems, and volatile! Because it's wiped on reboot.
    tmp.useTmpfs = lib.mkDefault true;

    # If not using tmpfs, which is naturally purged on reboot, we must clean it
    # /tmp ourselves. /tmp should be volatile storage!
    tmp.cleanOnBoot = lib.mkDefault (!config.boot.tmp.useTmpfs);

    # Fix a security hole in place for backwards compatibility. See desc in
    # nixpkgs/nixos/modules/system/boot/loader/systemd-boot/systemd-boot.nix
    loader.systemd-boot.editor = false;

    kernel.sysctl = {
      # The Magic SysRq key is a key combo that allows users connected to the
      # system console of a Linux kernel to perform some low-level commands.
      # Disable it, since we don't need it, and is a potential security concern.
      "kernel.sysrq" = 0;

      # Disable NMI watchdog
      "kernel.nmi_watchdog" = 0;

      # To hide any kernel messages from the console
      "kernel.printk" = "3 3 3 3";

      # Only swap when absolutely necessary
      "vm.swappiness" = "1";

      ## TCP hardening
      # Prevent bogus ICMP errors from filling up logs.
      "net.ipv4.icmp_ignore_bogus_error_responses" = 1;
      # Reverse path filtering causes the kernel to do source validation of
      # packets received from all interfaces. This can mitigate IP spoofing.
      "net.ipv4.conf.default.rp_filter" = 1;
      "net.ipv4.conf.all.rp_filter" = 1;
      # Do not accept IP source route packets (we're not a router)
      "net.ipv4.conf.all.accept_source_route" = 0;
      "net.ipv6.conf.all.accept_source_route" = 0;
      # Don't send ICMP redirects (again, we're on a router)
      "net.ipv4.conf.all.send_redirects" = 0;
      "net.ipv4.conf.default.send_redirects" = 0;
      # Refuse ICMP redirects (MITM mitigations)
      "net.ipv4.conf.all.accept_redirects" = 0;
      "net.ipv4.conf.default.accept_redirects" = 0;
      "net.ipv4.conf.all.secure_redirects" = 0;
      "net.ipv4.conf.default.secure_redirects" = 0;
      "net.ipv6.conf.all.accept_redirects" = 0;
      "net.ipv6.conf.default.accept_redirects" = 0;
      # Protects against SYN flood attacks
      "net.ipv4.tcp_syncookies" = 1;
      # Incomplete protection again TIME-WAIT assassination
      "net.ipv4.tcp_rfc1337" = 1;

      ## TCP optimization
      # TCP Fast Open is a TCP extension that reduces network latency by packing
      # data in the sender’s initial TCP SYN. Setting 3 = enable TCP Fast Open for
      # both incoming and outgoing connections:
      "net.ipv4.tcp_fastopen" = 3;
      # Bufferbloat mitigations + slight improvement in throughput & latency
      "net.ipv4.tcp_congestion_control" = "bbr";
      "net.core.default_qdisc" = "cake";
    };

    kernelModules = [ "tcp_bbr" ];

    blacklistedKernelModules = [
      # Novideo
      "nvidia"
      "nvidia-drm"
      "nvidia-modeset"
      "nouveau"

      # Obscure network protocols
      "ax25"
      "netrom"
      "rose"

      # Old or rare or insufficiently audited filesystems
      "adfs"
      "affs"
      "bfs"
      "befs"
      "cramfs"
      "efs"
      "erofs"
      "exofs"
      "freevxfs"
      "f2fs"
      "vivid"
      "gfs2"
      "ksmbd"
      "nfsv4"
      "nfsv3"
      "cifs"
      "nfs"
      "cramfs"
      "freevxfs"
      "jffs2"
      "hfs"
      "hfsplus"
      "squashfs"
      "udf"
      "btusb"
      "hpfs"
      "jfs"
      "minix"
      "nilfs2"
      "omfs"
      "qnx4"
      "qnx6"
      "sysv"
    ];
  };

  # So we don't have to do this later...
  security.acme.acceptTerms = true;
}
