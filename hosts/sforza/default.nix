{
  pkgs,
  lib,
  inputs,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    ./persist.nix
    ./users.nix

    inputs.chaotic.nixosModules.default
  ];

  # My own modules
  # FIXME:
  # mine = {
  #   games = {
  #     gamemode.enable = false;
  #     lutris.enable = false;
  #     steam.enable = false;
  #   };
  #   gnome = {
  #     enable = true;
  #     keyring.enable = true;
  #   };
  #   dnscrypt.enable = false;
  #   stubby.enable = false;
  #   fonts.enable = true;
  #   greetd.enable = true;
  #   security.enable = true;
  #   thunar.enable = true;
  #   qemu.enable = true;
  # };

  # Chaotic stuff
  environment = {
    variables = {
      RADV_PERFTEST = "aco,gpl";
      AMD_VULKAN_ICD = lib.mkDefault "RADV";
    };
  };
  chaotic = {
    mesa-git.enable = false;
    steam.extraCompatPackages = with pkgs; [
      luxtorpeda
      proton-ge-custom
    ];
    nyx = {
      cache.enable = false; # added manualy
      overlay.enable = true;
    };
  };

  documentation = {
    enable = true;
    doc.enable = true;
    man.enable = true;
    dev.enable = false;
  };

  services.logind = {
    powerKey = "suspend";
    lidSwitch = "suspend-then-hibernate";
  };

  # OpenGL
  hardware = {
    bluetooth.enable = true;
    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
      extraPackages = with pkgs; [
        # amdvlk
        rocmPackages.clr.icd
        rocmPackages.clr
      ];
      # extraPackages32 = with pkgs; [driversi686Linux.amdvlk];
    };
  };

  networking = {
    hostName = "sforza";
    useDHCP = false;
    defaultGateway = {
      address = "192.168.1.1";
      interface = "wlp4s0";
    };
    interfaces.enp3s0.useDHCP = true; # will override networking.useDHCP
    interfaces.wlp4s0 = {
      ipv4.addresses = [
        {
          address = "192.168.1.99";
          prefixLength = 24;
        }
      ];
    };
    networkmanager.enable = true;

    wg-quick.interfaces = {
      wg0 = {
        autostart = true;
        address = [ "10.66.66.2/32" ];
        dns = [ "45.76.145.144" ];
        privateKeyFile = "/persist/wireguard/privateKey";

        peers = [
          {
            publicKey = "hOxW74kF//JpljARxf4+lu+cbwgn8OtB+lXT2Tqoyhk=";
            presharedKeyFile = "/persist/wireguard/presharedKey";
            allowedIPs = [ "0.0.0.0/0" ];
            endpoint = "45.76.145.144:51820";
            persistentKeepalive = 25;
          }
        ];
      };
    };
  };

  # TLP For Laptop
  services = {
    tlp = {
      enable = true;
      settings = {
        CPU_SCALING_GOVERNOR_ON_AC = "performance";
        CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

        CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
        CPU_ENERGY_PERF_POLICY_ON_AC = "performance";

        CPU_MIN_PERF_ON_AC = 0;
        CPU_MAX_PERF_ON_AC = 100;
        CPU_MIN_PERF_ON_BAT = 0;
        CPU_MAX_PERF_ON_BAT = 50;
      };
    };
    power-profiles-daemon.enable = lib.mkForce false; # FIXME: gnome
    xserver = {
      enable = true;
      xkb.layout = "us"; # Configure keymap
      libinput.enable = true;
      displayManager.gdm.enable = true;
      desktopManager.gnome.enable = true; # FIXME: gnome
    };
  };

  environment.gnome.excludePackages =
    (with pkgs; [
      gnome-photos
      gnome-tour
      gedit # text editor
    ])
    ++ (with pkgs.gnome; [
      cheese # webcam tool
      gnome-music
      epiphany # web browser
      geary # email reader
      evince # document viewer
      gnome-characters
      totem # video player
      tali # poker game
      iagno # go game
      hitori # sudoku game
      atomix # puzzle game
    ]);
  programs.dconf.enable = true; # FIXME: gnome
}
