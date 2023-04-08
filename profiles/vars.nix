{
  config,
  pkgs,
  inputs,
  ...
}: {
  vars = rec {
    email = "ludovicopiero@pm.me";
    username = "ludovico";
    terminal = "kitty";
    terminalBin = "${pkgs.kitty}/bin/kitty";
    colorScheme = inputs.nix-colors.colorSchemes.catppuccin-mocha;

    home = "/home/${username}";
    configHome = (builtins.getAttr username config.home-manager.users).xdg.configHome;
    documentsFolder = "Documents";
    downloadFolder = "Downloads";
    musicFolder = "Music";
    picturesFolder = "Pictures";
    videosFolder = "Videos";
    repositoriesFolder = "Stuff";
    screenshotFolder = "${picturesFolder}/Screenshots";

    sshPublicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILHKPBn388QwATBB2GiXYirTYZ+Nd2GTbzaUryyuWi3A ludovicopiero@pm.me";
    stateVersion = "22.11";

    timezone = "Australia/Brisbane";
  };
}
