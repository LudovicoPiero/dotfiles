{
  pkgs,
  inputs,
  userName,
  ...
}:
let
  spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.system};
in
{
  home-manager.users.${userName} = {
    imports = [ inputs.spicetify-nix.homeManagerModules.default ];
    programs.spicetify = {
      enable = true;
      spotifyPackage = inputs.self.packages.${pkgs.system}.spotify;

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
