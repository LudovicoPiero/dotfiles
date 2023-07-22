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
    terminal = "screen-256color";
    terminalBin = "${lib.getExe pkgs.wezterm}";
    colorScheme = inputs.nix-colors.colorSchemes.catppuccin-mocha;

    home = "/home/${username}";
    inherit ((builtins.getAttr username config.home-manager.users).xdg) configHome;
    codeFolder = "Code";
    documentsFolder = "Documents";
    downloadFolder = "Downloads";
    gamesFolder = "Games";
    musicFolder = "Music";
    picturesFolder = "Pictures";
    recordFolder = "${videosFolder}/Record";
    screenshotFolder = "${picturesFolder}/Screenshot";
    videosFolder = "Videos";

    sshPublicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILHKPBn388QwATBB2GiXYirTYZ+Nd2GTbzaUryyuWi3A ludovicopiero@pm.me";
    stateVersion = "22.11";

    timezone = "Australia/Melbourne";
  };
}
