{
  lib,
  pkgs,
  config,
  inputs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.mine.zen-browser;
in
{
  imports = [
    ./settings.nix
    ./search.nix
    ./bookmarks.nix
    ./extensions.nix
  ];

  options.mine.zen-browser = {
    enable = mkEnableOption "Zen Browser";
  };

  config = mkIf cfg.enable {
    hm = {
      imports = [ ./modules ];
      programs.zen-browser = {
        enable = true;
        package = inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default;

        profiles = {
          ludovico = {
            id = 0;
            isDefault = true;
            name = "Ludovico";
          };
        };
      };
    };
  };
}
