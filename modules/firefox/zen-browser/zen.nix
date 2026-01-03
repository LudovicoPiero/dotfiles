{
  config,
  lib,
  inputs,
  pkgs,
  ...
}:
let
  cfg = config.mine.zen-browser;
in
{
  options.mine.zen-browser = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable zen-browser.";
    };

    package = lib.mkOption {
      type = lib.types.package;
      default = inputs.zen-browser.packages.${pkgs.stdenv.system}.beta;
      description = "The zen-browser package to install.";
    };
  };

  config = lib.mkIf cfg.enable {
    mine.programs.zen-browser = {
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
