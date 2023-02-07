{hmUsers, ...}: {
  home-manager.users = {inherit (hmUsers) ludovico;};

  users.users.ludovico = {
    password = "nixos"; #FIXME: Change later
    description = "default";
    isNormalUser = true;
    extraGroups = ["wheel"];
  };
}
