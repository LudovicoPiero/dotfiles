{
  lib,
  config,
  pkgs,
  ...
}: {
  programs.fish = {
    enable = true;
    shellInit = ''
      . /persist/github/stuff
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
      initialHashedPassword = "$y$j9T$zO8KlDu.ytfp5fXpKCfhs.$zX9lJfycTysyfsDvBoS9TgGbdXL7UJy9yLtITUPSpm7";
    };
    airi = {
      shell = pkgs.fish;
      initialHashedPassword = "$y$j9T$JCK0DAtEZLYkdj3OPJNOk0$4U63jpiNEpgW/GsJ/yG51TjiczM/mEaR6kFkRqtDZN.";
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
