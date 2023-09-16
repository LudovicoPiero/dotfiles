{
  config,
  pkgs,
  ...
}: {
  sops = {
    secrets = {
      "rootPassword" = {
        mode = "0440";
        neededForUsers = true;
      };
      "userPassword" = {
        mode = "0440";
        neededForUsers = true;
      };
      "githubToken" = {
        mode = "0444";
        owner = "ludovico";
      };
    };
  };

  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      . ${config.sops.secrets.githubToken.path}
    '';
  };

  users = {
    mutableUsers = false;
    users = {
      root.hashedPasswordFile = config.sops.secrets."rootPassword".path;
      ludovico = {
        shell = pkgs.fish;
        hashedPasswordFile = config.sops.secrets."userPassword".path;
        isNormalUser = true;
        extraGroups =
          ["seat" "wheel"]
          ++ pkgs.lib.optional config.virtualisation.libvirtd.enable "libvirtd"
          ++ pkgs.lib.optional config.virtualisation.docker.enable "docker"
          ++ pkgs.lib.optional config.networking.networkmanager.enable "networkmanager"
          ++ pkgs.lib.optional config.programs.light.enable "video";
      };
    };
  };
}
