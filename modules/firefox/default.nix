{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.mine.firefox;
in
{
  imports = [
    ./_modules.nix
    ./_mozilla.nix
  ];

  options.mine.firefox = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable Firefox.";
    };

    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.firefox;
      description = "The Firefox package to install.";
    };
  };

  config = lib.mkIf cfg.enable {
    mine.programs.firefox = {
      enable = true;
      inherit (cfg) package;

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
