{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    # Modules
    ../../modules/nixos/pipewireLowLatency.nix
  ];

  # Earlyoom prevents systems from locking up when they run out of memory
  services.earlyoom.enable = true;

  console = {
    # A good TTY font
    font = lib.mkDefault "${pkgs.terminus_font}/share/consolefonts/ter-u12n.psf.gz";
    colors = let
      colorscheme = inputs.nix-colors.colorSchemes.catppuccin-mocha;
    in
      with colorscheme.colors; [
        base01
        base08
        base0B
        base0A
        base0D
        base0E
        base0C
        base06
        base02
        base08
        base0B
        base0A
        base0D
        base0E
        base0C
        base07
      ];
  };

  programs.command-not-found.enable = false;

  # Thunar stuff
  programs.thunar.plugins = with pkgs.xfce; [
    thunar-archive-plugin
    thunar-volman
  ];
  services = {
    gvfs.enable = true; # Mount, trash, and other functionalities
    tumbler.enable = true; # Thumbnail support for images
  };

  environment = {
    pathsToLink = ["/share/fish"];

    # Font packages should go in `fonts.fonts` a few lines below this.
    systemPackages = lib.attrValues {
      inherit
        (pkgs)
        coreutils
        curl
        fd
        git
        home-manager
        man-pages
        man-pages-posix
        sops
        ripgrep
        vim
        wget
        ;

      inherit (pkgs.xfce) thunar;
    };
  };

  fonts = {
    fontDir.enable = true;
    fonts = with pkgs; [
      # Icons
      inputs.self.packages.${pkgs.system}.google-sans
      inputs.self.packages.${pkgs.system}.material-symbols

      # From Overlays directory
      iosevka-q

      powerline-fonts
      emacs-all-the-icons-fonts
      font-awesome
      sarasa-gothic
      noto-fonts-cjk
      noto-fonts-cjk-sans
      noto-fonts-emoji
      jetbrains-mono
      (nerdfonts.override {fonts = ["Iosevka"];})
    ];

    # use fonts specified by user rather than default ones
    enableDefaultFonts = false;
    fontconfig = {
      enable = true;
      defaultFonts = {
        serif = [
          "Google Sans"
          "Sarasa Gothic C"
          "Sarasa Gothic J"
          "Sarasa Gothic K"
        ];

        sansSerif = [
          "Google Sans"
          "Sarasa Gothic C"
          "Sarasa Gothic J"
          "Sarasa Gothic K"
        ];

        monospace = [
          "Iosevka Nerd Font"
          "Sarasa Mono C"
          "Sarasa Mono J"
          "Sarasa Mono K"
        ];

        emoji = ["noto-fonts-emoji"];
      };
    };
  };

  networking.nameservers = ["1.1.1.1" "1.0.0.1"];
  powerManagement.cpuFreqGovernor = "performance";

  qt.platformTheme = "qt5ct";

  security = {
    polkit.enable = true;
    sudo.enable = true;
    doas = {
      enable = true;
      extraRules = [
        {
          users = ["ludovico"];
          keepEnv = true;
          persist = true;
        }
      ];
    };
  };

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber.enable = true;

    # From Modules
    lowLatency.enable = true;
  };

  environment.etc = {
    "pipewire/pipewire-pulse.conf.d/00-autoswitch.conf".text = ''
      pulse.cmd = [
        { cmd = "load-module" args = "module-always-sink" flags = [ ] }
        { cmd = "load-module" args = "module-switch-on-connect" }
      ]
    '';
    "wireplumber/bluetooth.lua.d/51-bluez-config.lua".text = ''
      bluez_monitor.properties = {
          ["bluez5.enable-sbc-xq"] = true,
          ["bluez5.enable-msbc"] = true,
          ["bluez5.enable-hw-volume"] = true,
          ["bluez5.headset-roles"] = "[ hsp_hs hsp_ag hfp_hf hfp_ag ]"
      }
    '';
  };

  time.timeZone = "Australia/Melbourne";
  networking.networkmanager.enable = true;
  i18n = {
    defaultLocale = "en_AU.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "en_AU.UTF-8";
      LC_IDENTIFICATION = "en_AU.UTF-8";
      LC_MEASUREMENT = "en_AU.UTF-8";
      LC_MONETARY = "en_AU.UTF-8";
      LC_NAME = "en_AU.UTF-8";
      LC_NUMERIC = "en_AU.UTF-8";
      LC_PAPER = "en_AU.UTF-8";
      LC_TELEPHONE = "en_AU.UTF-8";
      LC_TIME = "en_AU.UTF-8";
    };
  };

  services.gnome.gnome-keyring.enable = true;
  systemd = {
    services.seatd = {
      enable = true;
      description = "Seat Management Daemon";
      script = "${pkgs.seatd}/bin/seatd -g wheel";
      serviceConfig = {
        Type = "simple";
        Restart = "always";
        RestartSec = 1;
      };
      wantedBy = ["multi-user.target"];
    };
    user.services = {
      pipewire.wantedBy = ["default.target"];
      pipewire-pulse.wantedBy = ["default.target"];
    };
    user.services.polkit-gnome-authentication-agent-1 = {
      description = "polkit-gnome-authentication-agent-1";
      wantedBy = ["graphical-session.target"];
      wants = ["graphical-session.target"];
      after = ["graphical-session.target"];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };
  };

  # Everything here is borrowed from @hlissner
  ## System security tweaks
  # sets hidepid=2 on /proc (make process info visible only to owning user)
  # NOTE Was removed on nixpkgs-unstable because it doesn't do anything
  # security.hideProcessInformation = true;
  # Prevent replacing the running kernel w/o reboot
  security.protectKernelImage = true;

  # tmpfs = /tmp is mounted in ram. Doing so makes temp file management speedy
  # on ssd systems, and volatile! Because it's wiped on reboot.
  boot.tmp.useTmpfs = lib.mkDefault true;
  # If not using tmpfs, which is naturally purged on reboot, we must clean it
  # /tmp ourselves. /tmp should be volatile storage!
  boot.tmp.cleanOnBoot = lib.mkDefault (!config.boot.tmp.useTmpfs);

  # Fix a security hole in place for backwards compatibility. See desc in
  # nixpkgs/nixos/modules/system/boot/loader/systemd-boot/systemd-boot.nix
  boot.loader.systemd-boot.editor = false;

  boot.kernel.sysctl = {
    # The Magic SysRq key is a key combo that allows users connected to the
    # system console of a Linux kernel to perform some low-level commands.
    # Disable it, since we don't need it, and is a potential security concern.
    "kernel.sysrq" = 0;

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
  boot.kernelModules = ["tcp_bbr"];

  # So we don't have to do this later...
  security.acme.acceptTerms = true;
}
