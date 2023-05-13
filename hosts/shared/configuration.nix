{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: {
  #TODO: FIX AGENIX
  # age = {
  #   identityPaths = ["/persist/etc/ssh/id_ed25519" "/persist/etc/ssh/id_rsa"];
  #   secrets = {
  #     userPassword.file = ../../secrets/userPassword.age;
  #     rootPassword.file = ../../secrets/rootPassword.age;
  #   };
  # };

  # Earlyoom prevents systems from locking up when they run out of memory
  services.earlyoom.enable = true;

  console = {
    # A good TTY font
    font = lib.mkDefault "${pkgs.terminus_font}/share/consolefonts/ter-u18n.psf.gz";
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

  users = {
    mutableUsers = false;
    users.root.hashedPassword = "$6$q6aVT9DEdwux5RuN$L2gzdL6EgMh6/gZisV0nDIU.f71x3cKTlZ9NWsD0urdntVb7AxTCVlW/jwAKQfKaAn9rCh47fKqD74gSEIR8s.";
    # users.root.passwordFile = config.age.secrets.rootPassword.path;
    users.ludovico = {
      # passwordFile = config.age.secrets.userPassword.path;
      hashedPassword = "$6$lWUeoIB0ygj2rDad$V5Bc.OB7tTpOEImflTmb0DqoKBmTVTK6PnqfhuG8YO0IjioC1pdFyFoDdInlM8NXrES5lmxGjBt9CSySxrsOj0";
      isNormalUser = true;
      home = "/home/ludovico";
      shell = pkgs.fish;

      extraGroups =
        [
          "wheel"
          "video"
          "audio"
          "realtime"
        ]
        ++ pkgs.lib.optional config.virtualisation.libvirtd.enable "libvirtd"
        ++ pkgs.lib.optional config.networking.networkmanager.enable "networkmanager";
    };
  };

  programs.command-not-found.enable = false;
  programs.fish.enable = true;

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
        home-manager
        man-pages
        man-pages-posix
        ripgrep
        wget
        git
        ;

      inherit
        (pkgs.xfce)
        thunar
        ;
    };
  };

  fonts = {
    fontDir.enable = true;
    fonts = with pkgs; [
      # Icons
      inputs.self.packages.${pkgs.system}.google-sans
      inputs.self.packages.${pkgs.system}.material-symbols

      powerline-fonts
      material-symbols
      iosevka-comfy.comfy
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
    sudo.enable = false;
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

  time.timeZone = "Australia/Brisbane";
  networking.networkmanager.enable = true;
  i18n = {
    defaultLocale = "en_US.UTF-8";
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

  nix = {
    settings = {
      # Prevent impurities in builds
      sandbox = true;

      # Give root user and wheel group special Nix privileges.
      trusted-users = ["root" "@wheel"];
      allowed-users = ["@wheel"];
    };

    # Improve nix store disk usage
    settings.auto-optimise-store = true;
    optimise.automatic = true;
  };
}
