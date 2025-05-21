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

  cfg = config.mine.CHANGEME;
in
{
  options.mine.CHANGEME = {
    enable = mkEnableOption "CHANGEME service";
    greeter = mkOption {
      type = types.str;
      default = "world";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.hello
    ];
  };
}
```
