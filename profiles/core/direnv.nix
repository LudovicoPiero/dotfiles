{config, ...}: {
  home-manager.users."${config.vars.username}".programs.direnv = {
    enable = true;
    nix-direnv = {
      enable = true;
    };
  };
}
