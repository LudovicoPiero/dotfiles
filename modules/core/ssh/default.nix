{
  config,
  lib,
  userName,
  ...
}:
let
  cfg = config.mine.ssh;
  inherit (lib) mkIf mkOption types;
in
{
  options.mine.ssh = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Enable ssh and set configuration.
      '';
    };
  };

  config = mkIf cfg.enable {
    home-manager.users.${userName} = {
      programs.ssh = {
        enable = true;

        matchBlocks = {
          github = {
            hostname = "github.com";
            identityFile = "/home/${userName}/.ssh/id_rsa";
          };
          gitlab = {
            hostname = "gitlab.com";
            identityFile = "/home/${userName}/.ssh/id_rsa";
          };
          sourcehut = {
            hostname = "git.sr.ht";
            identityFile = "/home/${userName}/.ssh/id_rsa";
          };
        };
      };
    };
  };
}
