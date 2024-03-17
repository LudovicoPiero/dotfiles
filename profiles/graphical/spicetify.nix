{
  pkgs,
  config,
  inputs,
  ...
}:
let
  spicePkgs = inputs.spicetify-nix.packages.${pkgs.system}.default;
in
{
  # nixpkgs.config.allowUnfreePredicate = pkg:
  #   builtins.elem (lib.getName pkg) [
  #     inputs.self.packages.${pkgs.system}.spotify
  #   ];
  home-manager.users.${config.vars.username} = {
    imports = [ inputs.spicetify-nix.homeManagerModule ];
    programs.spicetify = {
      enable = true;
      spotifyPackage = inputs.self.packages.${pkgs.system}.spotify;
      theme = spicePkgs.themes.catppuccin-mocha;
      colorScheme = "flamingo";

      enabledExtensions = with spicePkgs.extensions; [
        fullAppDisplay
        shuffle
        hidePodcasts
        adblock
      ];

      # enabledCustomApps = ["marketplace"];
    };
  };
}
