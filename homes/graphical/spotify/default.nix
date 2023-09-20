{
  pkgs,
  inputs,
  ...
}: let
  spicePkgs = inputs.spicetify-nix.packages.${pkgs.system}.default;
in {
  programs.spicetify = {
    enable = true;
    spotifyPackage = inputs.ludovico-nixpkgs.packages.${pkgs.system}.spotify;
    theme = spicePkgs.themes.catppuccin-mocha;
    # colorScheme = "flamingo";

    enabledExtensions = with spicePkgs.extensions; [
      fullAppDisplay
      shuffle
      hidePodcasts
      adblock
    ];

    # enabledCustomApps = ["marketplace"];
  };
}
