{config, ...}: {
  sops = {
    secrets."users/userPassword".neededForUsers = true;
    secrets."users/rootPassword".neededForUsers = true;
  };

  users = {
    mutableUsers = false;
    users.root.hashedPasswordFile = config.sops.secrets."users/rootPassword".path;
    users.${config.myOptions.vars.username} = {
      hashedPasswordFile = config.sops.secrets."users/userPassword".path;
      uid = 1001;
      isNormalUser = true;
      extraGroups = [
        "video"
        "wheel"
      ];
    };
  };
}
