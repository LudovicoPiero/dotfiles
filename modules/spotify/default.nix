{
  lib,
  pkgs,
  config,
  inputs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;

  spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.hostPlatform.system};

  cfg = config.mine.spotify;
in
{
  imports = [ inputs.spicetify-nix.nixosModules.default ];

  options.mine.spotify = {
    enable = mkEnableOption "spotify";
  };

  config = mkIf cfg.enable {
    programs.spicetify = {
      enable = true;
      experimentalFeatures = true;
      spotifyPackage = inputs.ludovico-pkgs.packages.${pkgs.stdenv.hostPlatform.system}.spotify;

      theme = spicePkgs.themes.text;
      colorScheme = "Spotify";

      enabledExtensions = with spicePkgs.extensions; [
        fullAppDisplay
        shuffle
        hidePodcasts
        adblock
      ];
    };
  };
}
