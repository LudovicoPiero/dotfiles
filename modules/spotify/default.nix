{
  lib,
  pkgs,
  config,
  inputs,
  ...
}: let
  inherit
    (lib)
    mkEnableOption
    mkIf
    mkOption
    types
    ;

  spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.hostPlatform.system};

  cfg = config.myOptions.spotify;
in {
  imports = [inputs.spicetify-nix.nixosModules.default];

  options.myOptions.spotify = {
    enable = mkEnableOption "spotify";
  };

  config = mkIf cfg.enable {
    programs.spicetify = {
      enable = true;
      spotifyPackage = inputs.ludovico-nixpkgs.packages.${pkgs.stdenv.hostPlatform.system}.spotify;

      theme = spicePkgs.themes.text;

      enabledExtensions = with spicePkgs.extensions; [
        fullAppDisplay
        shuffle
        hidePodcasts
        adblock
      ];
    };
  };
}
