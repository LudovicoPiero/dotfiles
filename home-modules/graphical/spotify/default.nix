{ pkgs
, inputs
, ...
}:
let
  spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.system};
in
{
  imports = [ inputs.spicetify-nix.homeManagerModules.default ];
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
  };
}
