{
  pkgs,
  inputs,
  ...
}: let
  spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.system};
in {
  programs.spicetify = {
    enable = true;
    spotifyPackage = inputs.self.packages.${pkgs.system}.spotify;
    theme = spicePkgs.themes.Dracula;
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
