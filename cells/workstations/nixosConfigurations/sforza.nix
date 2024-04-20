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
      profiles = with nixosProfiles; [
        # docker
        wireguard
        hardwareProfiles.sforza
      ];
      suites = with nixosSuites; sforza;
    in
    lib.concatLists [
      profiles
      suites
    ];

  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = true;
    users = {
      airi = {
        imports =
          let
            profiles = with homeProfiles; [
              emacs
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
        amdvlk
        rocmPackages.clr.icd
        rocmPackages.clr
      ];
      extraPackages32 = with pkgs; [ driversi686Linux.amdvlk ];
    };
  };

  networking = {
    hostName = "sforza";
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
