{
  config,
  lib,
  pkgs,
  options,
  input,
  sytem,
  ...
}: {
  age = {
    identityPaths = ["/home/ludovico/.ssh/id_ed25519" "/home/ludovico/.ssh/id_rsa"];
    secrets = {
      userPassword.file = ../../secrets/userPassword.age;
      rootPassword.file = ../../secrets/rootPassword.age;
    };
  };
  users = {
    mutableUsers = false;
    users.root.passwordFile = config.age.secrets.rootPassword.path;
    users.ludovico = {
      passwordFile = config.age.secrets.userPassword.path;
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
    };
  };

  fonts = {
    fontDir.enable = true;
    fonts = with pkgs; [
      # Icons
      # inputs.self.packages.${pkgs.system}.google-sans

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
          "Sarasa Gothic C"
          "Sarasa Gothic J"
          "Sarasa Gothic K"
        ];

        sansSerif = [
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
