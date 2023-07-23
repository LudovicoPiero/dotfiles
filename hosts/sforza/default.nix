{
  pkgs,
  lib,
  config,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ./persist.nix
  ];

  sops.secrets = {
    "wgPrivKey" = {
      mode = "0440";
    };
    "wgPreKey" = {
      mode = "0440";
    };
  };

  boot = {
    loader.systemd-boot.enable = true;
    loader.systemd-boot.configurationLimit = 5;
    loader.efi.canTouchEfiVariables = true;
    loader.efi.efiSysMountPoint = "/boot";
  };

  hardware.bluetooth.enable = true;

  # AAGL
  programs.honkers-railway-launcher.enable = true;

  # OpenGL
  environment.variables.AMD_VULKAN_ICD = lib.mkDefault "RADV";
  boot = {
    initrd.kernelModules = ["amdgpu"];
    kernelParams = ["amd_pstate=passive" "initcall_blacklist=acpi_cpufreq_init"];
    kernelModules = ["amd-pstate"];
  };
  hardware.opengl = {
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

  networking.networkmanager.enable = true;
  networking.hostName = "sforza";

  time.timeZone = "Australia/Melbourne";

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

  # TLP For Laptop
  services = {
    tlp.enable = lib.mkForce true;
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
  };

  services.greetd = let
    user = "ludovico";
    greetd = "${pkgs.greetd.greetd}/bin/greetd";
    gtkgreet = "${pkgs.greetd.gtkgreet}/bin/gtkgreet";

    sway-kiosk = command: "${pkgs.sway}/bin/sway --config ${pkgs.writeText "kiosk.config" ''
      output * bg #000000 solid_color
      exec dbus-update-activation-environment --systemd DISPLAY WAYLAND_DISPLAY SWAYSOCK

      # Just in case if greetd not working properly
      bindsym Mod4+Return exec wezterm
      exec "${command}; ${pkgs.sway}/bin/swaymsg exit"
    ''}";
  in {
    enable = true;
    vt = 7;
    settings = {
      default_session = {
        command = sway-kiosk "${gtkgreet} -l -c 'Hyprland'";
        inherit user;
      };
    };
  };

  environment.etc."greetd/environments".text = ''
    Hyprland
    fish
  '';

  services.xserver = {
    enable = true;
    layout = "us"; # Configure keymap
    libinput.enable = true;
    deviceSection = ''
      Option "TearFree" "true"
    '';

    displayManager = {
      lightdm.enable = false;
      sddm = {
        enable = false;
        # theme = "multicolor-sddm-theme";
      };
    };
  };

  networking.wg-quick.interfaces = {
    wg0 = {
      autostart = true;
      address = ["10.66.66.3/32" "fd42:42:42::3/128"];
      dns = ["1.1.1.1" "1.0.0.1"];
      privateKeyFile = config.sops.secrets.wgPrivKey.path;

      peers = [
        {
          publicKey = "6c2tFt3lF9+/UiSuxwrKBypON0U2y7wYGn9DWEBmi2A=";
          presharedKeyFile = config.sops.secrets.wgPreKey.path;
          allowedIPs = ["0.0.0.0/0" "::/0"];
          endpoint = "103.235.73.71:50935";
          persistentKeepalive = 25;
        }
      ];
    };
  };

  system.stateVersion = "23.05";
}
