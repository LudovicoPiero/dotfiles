{ pkgs, inputs, ... }:
{
  imports = [ ./__floorp-modules.nix ];
  programs.floorp = {
    enable = true;

    profiles = {
      ludovico = {
        id = 0;
        isDefault = true;
        name = "Ludovico";
        extensions = with inputs.firefox-addons.packages.${pkgs.system}; [
          bitwarden
          refined-github
          sponsorblock
          to-deepl
          ublock-origin
        ];
        bookmarks = import ./__bookmarks.nix;
        search = import ./__search.nix { inherit pkgs; };
        settings = import ./__settings.nix;
      };
    };
  };
}
