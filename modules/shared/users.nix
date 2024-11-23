{config, ...}: {
  sops.secrets."users/userPassword".neededForUsers = true;
  sops.secrets."users/rootPassword".neededForUsers = true;

  users.mutableUsers = false;
  users.users.root.hashedPasswordFile = config.sops.secrets."users/rootPassword".path;
  users.users.${config.myOptions.vars.username} = {
    hashedPasswordFile = config.sops.secrets."users/userPassword".path;
    uid = 1001;
    isNormalUser = true;
    extraGroups = [
      "video"
      "wheel"
    ];
  };
}
