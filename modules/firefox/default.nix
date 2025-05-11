{
  lib,
  pkgs,
  config,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.myOptions.firefox;
in
{
  imports = [
    ./preferences.nix
    ./policies.nix
  ];

  options.myOptions.firefox = {
    enable = mkEnableOption "firefox browser" // {
      default = config.vars.withGui;
    };
  };

  config = mkIf cfg.enable {
    programs.firefox = {
      enable = true;
      package = pkgs.firefox;
    };
  };
}
