{
  config,
  pkgs,
  lib,
  inputs,
  system,
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
        ++ pkgs.lib.optional config.virtualisation.docker.enable "docker"
        ++ pkgs.lib.optional config.networking.networkmanager.enable "networkmanager";
    };
  };

  # An anime game launcher
  programs = {
    anime-game-launcher.enable = true;
    anime-borb-launcher.enable = true;
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
    # kernelModules = ["amd-pstate"];
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

  virtualisation.libvirtd.enable = true; # Qemu
  environment.systemPackages = let
    myDwl = pkgs.dwl.overrideAttrs (oldAttrs: rec {
      # conf = ./config/config.def.h;
      src = pkgs.fetchFromGitHub {
        owner = "djpohly";
        repo = "dwl";
        rev = "main";
        hash = "sha256-MnEylBPuqZuZgRybMQt8OfnFMEVzUuntOQJrWlDr5p8=";
      };
      patches = [
        (pkgs.fetchpatch {
          url = "https://github.com/djpohly/dwl/compare/main...bencollerson:pertag.patch";
          sha256 = "sha256-5bviuTDBsXIKeuaDiP4SvJnYnGOGGjAX1Wxz1l/XMxk=";
        })
      ];
      configFile = pkgs.writeText "config.def.h" (builtins.readFile ./config/config.def.h);
      postPatch = "${oldAttrs.postPatch} \n cp ${configFile} config.def.h && sed -i '13s/^#//;14s/^#//' config.mk";
    });
    somebar = pkgs.somebar.overrideAttrs (oldAttrs: {
      prePatch = ''
        echo '#pragma once
        #include "common.hpp"
        constexpr bool topbar = true;
        constexpr int paddingX = 10;
        constexpr int paddingY = 3;
        constexpr const char* font = "Iosevka Nerd Font 9";
        constexpr ColorScheme colorInactive = {Color(0x42, 0x42, 0x42), Color(0xff, 0xff, 0xe8)};
        constexpr ColorScheme colorActive = {Color(0x42, 0x42, 0x42), Color(0xe8, 0xeb, 0x98)};
        constexpr const char* termcmd[] = {"foot", nullptr};
        static std::vector<std::string> tagNames = {
        	"1", "2", "3", "4", "5", "6", "7", "8", "9",
        };
        constexpr Button buttons[] = {
        	{ ClkStatusText, BTN_RIGHT, spawn, {.v = termcmd} },
        };'>src/config.hpp'';
    });
  in
    lib.attrValues {
      inherit
        (pkgs)
        authy
        catgirl
        discord-canary
        exa
        fzf
        gamescope
        lutris
        mailspring
        mangohud
        mpv
        neofetch
        nitch
        protonup-qt
        ripgrep
        steam
        tdesktop
        webcord-vencord
        virt-manager
        virt-viewer
        qemu
        OVMF
        gvfs
        ;

      inherit
        (inputs.nixpkgs-wayland.packages.${system})
        grim
        slurp
        wf-recorder
        wl-clipboard
        wlogout
        ;

      inherit myDwl;
      inherit somebar;
      runDwl = pkgs.writers.writeDashBin "runDwl" ''
        dwl -s somebar & dunst
        systemctl --user restart xdg-desktop-portal xdg-desktop-portal-gtk xdg-desktop-portal-hyprland
      '';

      inherit (pkgs.qt6) qtwayland;
      inherit (inputs.nil.packages.${system}) default;
      inherit (inputs.hyprland-contrib.packages.${system}) grimblast;

      # use OCR and copy to clipboard
      ocrScript = let
        inherit (pkgs) grim libnotify slurp tesseract5 wl-clipboard;
        _ = lib.getExe;
      in
        pkgs.writers.writeDashBin "wl-ocr" ''
          ${_ grim} -g "$(${_ slurp})" -t ppm - | ${_ tesseract5} - - | ${wl-clipboard}/bin/wl-copy
          ${_ libnotify} "$(${wl-clipboard}/bin/wl-paste)"
        '';
    };
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

  # unlock GPG keyring on login
  security = {
    pam.services.greetd.gnupg.enable = true;
    pam.services.greetd.enableGnomeKeyring = true;
    pam.services.swaylock.text = "auth include login";
  };
  environment.etc."greetd/environments".text = ''
    Hyprland
    runDwl
    sway
    fish
  '';

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

      SOUND_POWER_SAVE_ON_AC = 0;
    };

    greetd = {
      enable = true;
      vt = 7;
      settings = {
        default_session = {
          command = "${lib.getExe pkgs.greetd.tuigreet} --time --cmd sway";
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
    extraPortals = with pkgs;
    with inputs; [
      xdg-desktop-portal-gtk
      # xdph.packages.${pkgs.system}.default
    ];
  };

  networking.wg-quick.interfaces = {
    wg0 = {
      autostart = true;
      address = ["10.66.66.3/32" "fd42:42:42::3/128"];
      dns = ["139.180.135.207"];
      privateKeyFile = config.sops.secrets.wireguardPrivateKey.path;

      peers = [
        {
          publicKey = "igZ4WvPhX3UK/jxPTeXtkQVJMK/OloWUJ9nyKBijsAg=";
          presharedKeyFile = config.sops.secrets.wireguardPresharedKey.path;
          allowedIPs = ["0.0.0.0/0" "::/0"];
          endpoint = "139.180.135.207:56287";
          persistentKeepalive = 25;
        }
      ];
    };
  };

  # Remove Bloat
  documentation.doc.enable = lib.mkForce false;
}
