{
  config,
  lib,
  userName,
  ...
}:
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
    home-manager.users.${userName} = {
      programs.direnv = {
        enable = true;
        nix-direnv = {
          enable = true;
        };
      };
    };
  };
}
