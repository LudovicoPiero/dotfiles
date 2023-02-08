{
  self,
  config,
  pkgs,
  inputs,
  ...
}: {
  vars = rec {
    email = "ludovicopiero@pm.me";
    username = "ludovico";
    terminal = "wezterm";
    terminalBin = "${pkgs.wezterm}/bin/wezterm";
    colorScheme = inputs.nix-colors.colorSchemes.catppuccin;

    home = "/home/${username}";
    configHome = (builtins.getAttr username config.home-manager.users).xdg.configHome;
    sshPublicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILHKPBn388QwATBB2GiXYirTYZ+Nd2GTbzaUryyuWi3A ludovicopiero@pm.me";
    stateVersion = "22.11";

    timezone = "Australia/Darwin";
  };
}
