{
  config,
  inputs,
  lib,
  ...
}:
{
  imports = [
    inputs.hjem.nixosModules.default
    (lib.modules.mkAliasOptionModule [ "hj" ] [ "hjem" "users" config.vars.username ]) # Stolen from gitlab/fazzi
  ];

  hjem = {
    clobberByDefault = true;
    extraModules = [ inputs.hjem-rum.hjemModules.default ];

    users.${config.vars.username} = {
      enable = true;
      user = config.vars.username;
    };
  };
}
