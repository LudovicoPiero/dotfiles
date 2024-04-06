{ config, ... }:
{
  programs.ssh = {
    enable = true;

    matchBlocks = {
      github = {
        hostname = "github.com";
        identityFile = "/home/${config.home.username}/.ssh/id_rsa";
      };
      gitlab = {
        hostname = "gitlab.com";
        identityFile = "/home/${config.home.username}/.ssh/id_rsa";
      };
      sourcehut = {
        hostname = "git.sr.ht";
        identityFile = "/home/${config.home.username}/.ssh/id_rsa";
      };
    };
  };
}
