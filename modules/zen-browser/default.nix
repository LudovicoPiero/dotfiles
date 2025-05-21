{
  lib,
  pkgs,
  config,
  inputs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;

  modulePath = [
    "mine"
    "programs"
    "zen-browser"
  ];

  mkFirefoxModule = import ../firefox/modules/mkFirefoxModule.nix;

  cfg = config.mine.zen-browser;
in
{
  imports = [
    (mkFirefoxModule {
      inherit modulePath;
      name = "Zen Browser";
      wrappedPackageName = "zen-browser";
      unwrappedPackageName = "zen-browser-unwrapped";
      visible = true;

      platforms.linux = {
        vendorPath = ".zen";
        configPath = ".zen";
      };
      platforms.darwin = {
        configPath = "Library/Application Support/Zen";
      };
    })

    ./settings.nix
    ./search.nix
    ./bookmarks.nix
    ./extensions.nix
  ];

  options.mine.zen-browser = {
    enable = mkEnableOption "Zen Browser";
  };

  config = mkIf cfg.enable {
    mine.programs.zen-browser = {
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
}
