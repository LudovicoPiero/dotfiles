{
  lib,
  config,
  inputs',
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.mine.nvim;
in
{
  options.mine.nvim = {
    enable = mkEnableOption "nvim";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ inputs'.ludovico-nixvim.packages.nvim ];
  };
}
