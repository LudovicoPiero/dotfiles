{
  pkgs,
  inputs,
  config,
  ...
}: let
  spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.system};
  inherit (config.colorScheme) colors;
in {
  programs.spicetify = {
    enable = true;
    spotifyPackage = inputs.self.packages.${pkgs.system}.spotify;

    theme = spicePkgs.themes.text;
    colorScheme = "mocha";

    enabledExtensions = with spicePkgs.extensions; [
      fullAppDisplay
      shuffle
      hidePodcasts
      adblock
    ];

    # enabledCustomApps = ["marketplace"];
  };
}
