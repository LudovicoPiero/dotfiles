{
  lib,
  config,
  pkgs,
  cell,
  inputs,
  ...
}:
let
  inherit (cell) secrets;
in
{
  imports = [ secrets.users ];

  sops.secrets = {
    "rootPassword" = {
      mode = "0440";
      neededForUsers = true;
      sopsFile = "${inputs.self}/cells/workstations/secrets/users.yaml";
    };
    "userPassword" = {
      mode = "0440";
      neededForUsers = true;
      sopsFile = "${inputs.self}/cells/workstations/secrets/users.yaml";
    };
    "githubToken" = {
      mode = "0444";
      owner = "airi";
      sopsFile = "${inputs.self}/cells/workstations/secrets/users.yaml";
    };
    "HF_API_KEY" = {
      mode = "0444";
      owner = "airi";
      sopsFile = "${inputs.self}/cells/workstations/secrets/users.yaml";
    };
  };

  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      . ${config.sops.secrets.githubToken.path}
      . ${config.sops.secrets.HF_API_KEY.path}
    '';
  };

  /*
    If set to false, the contents of the user and group files will simply be replaced on system activation.
    This also holds for the user passwords; all changed passwords will be reset according to the
    users.users configuration on activation.
  */
  users.mutableUsers = false;
  users.users = {
    root = {
      hashedPasswordFile = config.sops.secrets.rootPassword.path;
    };
    airi = {
      shell = pkgs.fish;
      hashedPasswordFile = config.sops.secrets.userPassword.path;
      isNormalUser = true;
      uid = 1000;
      extraGroups =
        [
          "seat"
          "wheel"
          "video"
        ]
        ++ lib.optional config.virtualisation.libvirtd.enable "libvirtd"
        ++ lib.optional config.virtualisation.docker.enable "docker"
        ++ lib.optional config.networking.networkmanager.enable "networkmanager";
    };
  };
}
