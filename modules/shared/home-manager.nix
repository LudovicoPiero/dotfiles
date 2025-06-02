{
  config,
  inputs,
  lib,
  ...
}:
{
  imports = [
    inputs.home-manager.nixosModules.home-manager
    (lib.modules.mkAliasOptionModule [ "hm" ] [ "home-manager" "users" config.vars.username ])
  ];

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;

  hm =
    { osConfig, ... }:
    {
      home.stateVersion = osConfig.vars.stateVersion;
    };
}
