{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ./persist.nix

    # Shared Configuration
    ../shared/configuration.nix
  ];

  sops = {
    defaultSopsFile = ./secrets.yaml;
    age.sshKeyPaths = ["/home/ludovico/.ssh/id_ed25519" "/home/ludovico/.ssh/id_rsa"];
    secrets.ludovico.neededForUsers = true;
    secrets.root.neededForUsers = true;
    secrets.wireguardPrivateKey = {
      inherit (config.users.users.systemd-network) group;
      reloadUnits = ["systemd-networkd.service"];
      mode = "0640";
    };
    secrets.wireguardPresharedKey = {
      inherit (config.users.users.systemd-network) group;
      reloadUnits = ["systemd-networkd.service"];
      mode = "0640";
    };
  };

  users = {
    mutableUsers = false;
    users.root.passwordFile = config.sops.secrets.root.path;
    users.ludovico = {
      passwordFile = config.sops.secrets.ludovico.path;
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

  # An anime game launcher
  programs = {
    anime-game-launcher.enable = true;
    honkers-railway-launcher.enable = true;
  };

  boot = {
    loader.systemd-boot.enable = true;
    loader.systemd-boot.configurationLimit = 5;
    loader.efi.canTouchEfiVariables = true;
    loader.efi.efiSysMountPoint = "/boot";
    kernelPackages = pkgs.linuxPackages_xanmod_latest;
    supportedFilesystems = ["ntfs" "btrfs"];
  };

  hardware.bluetooth.enable = true;

  # OpenGL
  environment.variables.AMD_VULKAN_ICD = lib.mkDefault "RADV"; # AMDVLK or RADV
  boot = {
    initrd.kernelModules = ["amdgpu"];
    kernelParams = ["amd_pstate=passive" "initcall_blacklist=acpi_cpufreq_init"];
    kernelModules = ["amd-pstate"];
  };
  hardware = {
    enableRedistributableFirmware = true;
    cpu.amd.updateMicrocode = true;
    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
      extraPackages = with pkgs; [
        # amdvlk
        rocm-opencl-icd
        rocm-opencl-runtime
      ];
      # extraPackages32 = with pkgs; [driversi686Linux.amdvlk];
    };
  };

  # Qemu
  virtualisation.libvirtd.enable = true;
  environment.systemPackages = with pkgs; [
    virt-manager
    virt-viewer
    qemu
    OVMF
    gvfs
  ];
  services.gvfs.enable = true;

  programs = {
    gamemode = {
      enable = true;
      settings = {
        custom = {
          start = "${pkgs.libnotify}/bin/notify-send 'GameMode started'";
          end = "${pkgs.libnotify}/bin/notify-send 'GameMode ended'";
        };
      };
    };
    fish.enable = true;
    hyprland.enable = true;
  };

  # TLP For Laptop
  services = {
    tlp.enable = true;
    tlp.settings = {
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
      RADEON_DPM_STATE_ON_AC = "performance";
      RADEON_DPM_STATE_ON_BAT = "battery";

      # https://linrunner.de/en/tlp/docs/tlp-faq.html#battery
      # use "tlp fullcharge" to override temporarily
      START_CHARGE_THRESH_BAT0 = 85;
      STOP_CHARGE_THRESH_BAT0 = 90;
      START_CHARGE_THRESH_BAT1 = 85;
      STOP_CHARGE_THRESH_BAT1 = 90;
    };

    greetd = {
      enable = true;

      settings = {
        default_session.command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd 'Hyprland'";

        initial_session = {
          command = "Hyprland";
          user = "ludovico";
        };
      };
    };

    xserver = {
      enable = true;
      layout = "us"; # Configure keymap
      libinput.enable = true;
      deviceSection = ''
        Option "TearFree" "true"
      '';

      displayManager = {
        lightdm.enable = false;
      };
    };
  };

  xdg.portal = {
    enable = true;
    wlr.enable = lib.mkForce false;
  };

  networking.wg-quick.interfaces = {
    wg0 = {
      autostart = false;
      address = ["10.66.66.2/32" "fdc9:281f:04d7:9ee9::2/128"];
      dns = ["139.84.195.170"];
      # dns = ["1.1.1.1"];
      privateKeyFile = config.sops.secrets.wireguardPrivateKey.path;

      peers = [
        {
          publicKey = "llWdOpPUakDWBB85BIOg2Bqr88k+B/0LguzzpxZUozU=";
          presharedKeyFile = config.sops.secrets.wireguardPresharedKey.path;
          allowedIPs = ["0.0.0.0/0" "::/0"];
          endpoint = "139.84.195.170:52780";
          persistentKeepalive = 25;
        }
      ];
    };
  };

  # Remove Bloat
  documentation.nixos.enable = lib.mkForce false;
}
