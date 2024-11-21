Modules Template
```nix
{ lib, pkgs, config, ... }:                     
let
  inherit (lib)
    mkEnableOption
    mkIf
    mkOption
    types
    ;

  cfg = config.services.CHANGEME;
in {
  options.services.CHANGEME = {
    enable = mkEnableOption "CHANGEME service";
    greeter = mkOption {
      type = types.str;
      default = "world";
    };
  };

  config = mkIf cfg.enable {
    home-manager.users.users.${config.myOptions.vars.username} = {}; # For Home-Manager options
    systemd.services.CHANGEME = {
      wantedBy = [ "multi-user.target" ];
      serviceConfig.ExecStart = "${pkgs.CHANGEME}/bin/CHANGEME -g'CHANGEME, ${escapeShellArg cfg.greeter}!'";
    };
  };
}
```