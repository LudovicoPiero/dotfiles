{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  vars = rec {
    email = "ludovicopiero@pm.me";
    username = "ludovico";
    terminal = "xterm-256color";
    terminalBin = "${lib.getExe pkgs.wezterm}";
    colorScheme = inputs.nix-colors.colorSchemes.catppuccin-mocha;

    home = "/home/${username}";
    inherit ((builtins.getAttr username config.home-manager.users).xdg) configHome;
    documentsFolder = "Documents";
    downloadFolder = "Downloads";
    musicFolder = "Music";
    picturesFolder = "Pictures";
    videosFolder = "Videos";
    repositoriesFolder = "Stuff";
    screenshotFolder = "${picturesFolder}/Screenshots";

    sshPublicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILHKPBn388QwATBB2GiXYirTYZ+Nd2GTbzaUryyuWi3A ludovicopiero@pm.me";
    stateVersion = "22.11";

    timezone = "Australia/Melbourne";
  };
}
