{ config, lib, ... }:
let
  cfg = config.mine.direnv;
  inherit (lib) mkIf mkOption types;
in
{
  options.mine.direnv = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Enable direnv and set configuration.
      '';
    };
  };

  config = mkIf cfg.enable {
    programs.direnv = {
      enable = true;
      nix-direnv = {
        enable = true;
      };
    };
  };
}
