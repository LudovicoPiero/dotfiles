Modules Template
```nix
{
  lib,
  pkgs,
  config,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    mkIf
    mkOption
    types
    ;

  cfg = config.myOptions.CHANGEME;
in
{
  options.myOptions.CHANGEME = {
    enable = mkEnableOption "CHANGEME service";
    greeter = mkOption {
      type = types.str;
      default = "world";
    };
  };

  config = mkIf cfg.enable {
    home-manager.users.${config.myOptions.vars.username} = { }; # For Home-Manager options
  };
}
```
