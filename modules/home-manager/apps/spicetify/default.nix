{
  pkgs,
  unstable,
  lib,
  spicetify-nix,
  ...
}: {
  # allow spotify to be installed if you don't have unfree enabled already
  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      "spotify-unwrapped"
    ];

  # configure spicetify :)
  programs.spicetify = {
    enable = true;
    theme = "catppuccin-mocha";
    # OR
    # theme = spicetify-nix.pkgSets.${pkgs.system}.themes.catppuccin-mocha;
    colorScheme = "flamingo";

    enabledExtensions = [
      "fullAppDisplay.js"
      "shuffle+.js"
      "hidePodcasts.js"
      "adblock.js"
    ];

    # enabledCustomApps = ["marketplace"];
  };
}
