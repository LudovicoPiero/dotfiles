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

  cfg = config.myOptions.spotify;
in
{
  imports = [ inputs.spicetify-nix.nixosModules.default ];

  options.myOptions.spotify = {
    enable = mkEnableOption "spotify" // {
      default = config.vars.withGui;
    };
  };

  config = mkIf cfg.enable {
    programs.spicetify = {
      enable = true;
      experimentalFeatures = true;
      spotifyPackage = inputs.self.packages.${pkgs.stdenv.hostPlatform.system}.spotify;

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
