{ lib, config, ... }:
let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.mine.direnv;
in
{
  options.mine.direnv = {
    enable = mkEnableOption "Direnv" // {
      default = config.mine.fish.enable;
    };
  };

  config = mkIf cfg.enable {
    hm = {
      programs.direnv = {
        enable = true;
        nix-direnv.enable = true;
      };
    };
  };
}
