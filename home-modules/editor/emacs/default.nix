{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.mine.emacs;
  inherit (lib) mkEnableOption mkIf;
in {
  options.mine.emacs.enable = mkEnableOption "emacs";

  config = mkIf cfg.enable {
    # WIP
    home.packages = with pkgs; [emacs];
  };
}
