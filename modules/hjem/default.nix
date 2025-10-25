{
  inputs,
  lib,
  config,
  pkgs,
  ...
}:
{
  options.mine.hjem = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable hjem configuration";
    };
  };

  imports = [
    inputs.hjem.nixosModules.default
    (lib.mkAliasOptionModule [ "hj" ] [ "hjem" "users" config.vars.username ])
  ];

  config = lib.mkIf config.mine.hjem.enable {
    hjem = {
      clobberByDefault = true;
      linker = inputs.hjem.packages.${pkgs.stdenv.hostPlatform.system}.smfh;
      users = {
        "${config.vars.username}" = {
          user = "${config.vars.username}";
          directory = "/home/${config.vars.username}";
        };
      };
    };
  };
}
