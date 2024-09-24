{
  cell,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  inherit (cell)
    homeProfiles
    homeSuites
    hardwareProfiles
    nixosProfiles
    nixosSuites
    ;
in
{
  bee = {
    system = "x86_64-linux";
    pkgs = import inputs.nixpkgs {
      inherit (inputs.nixpkgs) system;
      config.allowUnfree = true;
      config.allowBroken = true;
      overlays = [
        inputs.chaotic-nyx.overlays.default
        inputs.lix-module.overlays.default
      ];
    };
    home = inputs.home-manager;
  };

  imports =
    let
      profiles = [
        # nixosProfiles.docker
        nixosProfiles.wireguard
        # nixosProfiles.dnscrypt2
        hardwareProfiles.sforza
      ];
      suites = with nixosSuites; sforza;
    in
    lib.concatLists [
      profiles
      suites
    ];

  # Roll back to blank snapshot on boot
  boot.initrd.postDeviceCommands = lib.mkAfter ''
    zfs rollback -r tank/local/root@blank
  '';

  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = true;
    users = {
      airi = {
        imports =
          let
            profiles = with homeProfiles; [
              playerctld
              mpd
              obs-studio
            ];
            suites = with homeSuites; airi;
          in
          lib.concatLists [
            profiles
            suites
          ];
      };
    };
  };

  documentation = {
    enable = false;
    doc.enable = false;
    nixos.enable = false;
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
    graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [
        rocmPackages.clr.icd
        rocmPackages.clr
      ];
    };
  };

  networking = {
    hostName = "sforza";
    hostId = "22e9b5ca"; # head -c8 /etc/machine-id
    useDHCP = lib.mkDefault true;
    enableIPv6 = false; # L ISP
    networkmanager.enable = true;
  };

  # TLP For Laptop
  services = {
    tlp = {
      enable = true;
      settings = {
        CPU_SCALING_GOVERNOR_ON_AC = "performance";
        CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
      };
    };
  };
}
