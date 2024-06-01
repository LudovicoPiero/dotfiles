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

  /*
    TODO:
    - Do the FIXME part.
    - Move Filesystems part to hardwareProfiles.
    - Create nixosSuites.
    - Create homeSuites.
  */

  # imports =
  #   let
  #     profiles = [
  #       # nixosProfiles.docker
  #     ];
  #     suites = with nixosSuites; sforza;
  #   in
  #   lib.concatLists [
  #     profiles
  #     suites
  #   ];

  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = true;
    users = {
      #FIXME: Change username
      CHANGEME = {
        imports =
          let
            profiles = with homeProfiles; [ obs-studio ];
          in
          #FIXME:
          # suites = with homeSuites; airi;
          lib.concatLists [
            profiles
            # suites
          ];
      };
    };
  };

  # OpenGL
  hardware = {
    # bluetooth.enable = true;
    # opengl = {
    #   enable = true;
    #   driSupport = true;
    #   driSupport32Bit = true;
    #   extraPackages = with pkgs; [
    #     rocmPackages.clr.icd
    #     rocmPackages.clr
    #   ];
    # };
  };

  networking = {
    hostName = "CHANGEME"; # FIXME: Change hostname
    # useDHCP = lib.mkDefault true;
    # enableIPv6 = false; # L ISP
    # networkmanager.enable = true;
  };
}
