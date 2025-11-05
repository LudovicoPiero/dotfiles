{
  config,
  lib,
  inputs',
  ...
}:
let
  cfg = config.mine.zen-browser;
in
{
  imports = [
    ./_modules.nix
    ./_mozilla.nix
  ];

  options.mine.zen-browser = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable zen-browser.";
    };

    package = lib.mkOption {
      type = lib.types.package;
      inherit (inputs'.zen-browser.packages) default;
      description = "The zen-browser package to install.";
    };
  };

  config = lib.mkIf cfg.enable {
    mine.programs.zen-browser = {
      enable = true;

      package = cfg.package;

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
