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
    #TODO: Module options for zen-browser can be added here
    hj.packages = [ cfg.package ];
  };
}
