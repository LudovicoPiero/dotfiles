{ lib, config, ... }:
{
  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 50;
    priority = 100;
  };

  boot = {
    # Mount /tmp in RAM. Faster, cleaner.
    tmp.useTmpfs = lib.mkDefault true;
    tmp.cleanOnBoot = lib.mkDefault (!config.boot.tmp.useTmpfs);

    # Networking: Use BBR + CAKE for better throughput and less lag
    kernelModules = [ "tcp_bbr" ];
    kernel.sysctl = {
      "net.ipv4.tcp_congestion_control" = "bbr";
      "net.core.default_qdisc" = "cake";
      "net.ipv4.tcp_fastopen" = 3;

      # Allows some useful caching
      "vm.swappiness" = 10;

      # Security: Hide kernel pointers & restrict dmesg
      "kernel.kptr_restrict" = 2;
      "kernel.dmesg_restrict" = 1;
      "kernel.printk" = "3 3 3 3";

      # Security: Protect hardlinks/symlinks
      "fs.protected_hardlinks" = 1;
      "fs.protected_symlinks" = 1;

      # Magic SysRq: 176 allows Sync, Unmount, Reboot (useful for freezes)
      "kernel.sysrq" = 176;

      # TCP Hardening
      "net.ipv4.icmp_ignore_bogus_error_responses" = 1;
      "net.ipv4.conf.default.rp_filter" = 1;
      "net.ipv4.conf.all.rp_filter" = 1;
      "net.ipv4.tcp_syncookies" = 1;
    };

    # Only blacklist truly useless modules for a desktop
    blacklistedKernelModules = [
      "nvidia"
      "nvidia-drm"
      "nvidia-modeset"
      "nouveau"
      "ax25"
      "netrom"
      "rose"
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
}
