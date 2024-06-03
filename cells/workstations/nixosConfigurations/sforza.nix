{
  cell,
  lib,
  pkgs,
  ...
}:
let
  inherit (cell)
    bee
    homeProfiles
    homeSuites
    hardwareProfiles
    nixosProfiles
    nixosSuites
    ;
in
{
  inherit bee;

  imports =
    let
      profiles = [
        # nixosProfiles.docker
        nixosProfiles.wireguard
        nixosProfiles.dnscrypt2
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
            profiles = with homeProfiles; [ obs-studio ];
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
    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
      extraPackages = with pkgs; [
        rocmPackages.clr.icd
        rocmPackages.clr
      ];
    };
  };

  networking = {
    hostName = "sforza";
    hostId = "1a122b84"; # head -c8 /etc/machine-id
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
