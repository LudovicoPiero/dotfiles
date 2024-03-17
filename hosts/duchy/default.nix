{ config, suites, ... }:
{
  imports = [ ./configuration.nix ] ++ suites.base;

  wsl = {
    enable = true;
    # automountPath = "/mnt";
    defaultUser = "ludovico";
    startMenuLaunchers = true;
    wslConf = {
      automount.root = "/mnt";
      network.hostname = "duchy";
    };
  };

  system.stateVersion = "${config.vars.stateVersion}";
}
