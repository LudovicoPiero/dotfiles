{ lib, config, ... }:
{
  # Enable zram-based swap
  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 50;
    priority = 100;
  };

  environment.defaultPackages = lib.mkDefault [ ];

  boot = {
    # tmpfs = /tmp is mounted in RAM for speed and volatility.
    tmp.useTmpfs = lib.mkDefault true;
    # Clean /tmp on boot if tmpfs is not in use.
    tmp.cleanOnBoot = lib.mkDefault (!config.boot.tmp.useTmpfs);

    # Disable systemd-boot editor to fix a backwards compatibility security issue.
    loader.systemd-boot.editor = false;

    kernel.sysctl = {
      # Disable Magic SysRq key for security.
      "kernel.sysrq" = 0;
      # Disable NMI watchdog.
      "kernel.nmi_watchdog" = 0;
      # Hide kernel messages from the console.
      "kernel.printk" = "3 3 3 3";
      # Minimize swap usage.
      "vm.swappiness" = "1";

      # Restrict kernel pointer exposure to mitigate potential kernel info leaks.
      "kernel.kptr_restrict" = 2;

      # Limit ptrace scope to prevent unprivileged processes from debugging others.
      "kernel.yama.ptrace_scope" = 1;

      # Protect against hardlink and symlink attacks.
      "fs.protected_hardlinks" = 1;
      "fs.protected_symlinks" = 1;

      # Disable kexec loading to prevent replacing the running kernel without a reboot.
      "kernel.kexec_load_disabled" = 1;

      # Disable core dumps for setuid programs to protect sensitive information.
      "fs.suid_dumpable" = 0;

      # Restrict performance event usage to mitigate potential side-channel attacks.
      "kernel.perf_event_paranoid" = 2;

      ## TCP hardening
      # Ignore bogus ICMP error responses.
      "net.ipv4.icmp_ignore_bogus_error_responses" = 1;
      # Enable reverse path filtering.
      "net.ipv4.conf.default.rp_filter" = 1;
      "net.ipv4.conf.all.rp_filter" = 1;
      # Do not accept source route packets.
      "net.ipv4.conf.all.accept_source_route" = 0;
      "net.ipv6.conf.all.accept_source_route" = 0;
      # Disable sending redirects.
      "net.ipv4.conf.all.send_redirects" = 0;
      "net.ipv4.conf.default.send_redirects" = 0;
      # Refuse and disable ICMP redirects.
      "net.ipv4.conf.all.accept_redirects" = 0;
      "net.ipv4.conf.default.accept_redirects" = 0;
      "net.ipv4.conf.all.secure_redirects" = 0;
      "net.ipv4.conf.default.secure_redirects" = 0;
      "net.ipv6.conf.all.accept_redirects" = 0;
      "net.ipv6.conf.default.accept_redirects" = 0;
      # Protect against SYN flood attacks.
      "net.ipv4.tcp_syncookies" = 1;
      # Incomplete protection for TIME_WAIT assassination.
      "net.ipv4.tcp_rfc1337" = 1;
      # Enable TCP Fast Open.
      "net.ipv4.tcp_fastopen" = 3;
      # Use BBR for congestion control and CAKE for queueing.
      "net.ipv4.tcp_congestion_control" = "bbr";
      "net.core.default_qdisc" = "cake";
    };

    # Enable BBR kernel module.
    kernelModules = [ "tcp_bbr" ];

    # Blacklist unnecessary or potentially insecure kernel modules.
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

  # Automatically accept ACME terms.
  security.acme.acceptTerms = true;
}
