Template for nix modules

```nix
{
  config,
  lib,
  inputs',
  ...
}:
let
  inherit (lib) mkOption types mkIf;
  cfg = config.mine.CHANGEME;
in
{
  options.mine.CHANGEME = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable CHANGEME.";
    };

    package = mkOption {
      type = types.package;
      default = inputs'.CHANGEME.packages.default;
      description = "The CHANGEME package to install.";
    };
  };

  config = mkIf cfg.enable {
    #TODO: Module options for CHANGEME can be added here
    hj.packages = [ cfg.package ];
  };
}
```
