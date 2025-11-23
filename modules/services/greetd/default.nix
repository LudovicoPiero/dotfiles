{
  config,
  lib,
  inputs',
  ...
}:
let
  inherit (lib) mkOption types mkIf;
  cfg = config.mine.greetd;

  oldNixpkgs = inputs'.nixpkgs-cage.legacyPackages;
  _ = lib.getExe;
in
{
  options.mine.greetd = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable greetd.";
    };
  };

  config = mkIf cfg.enable {
    services.greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "${_ oldNixpkgs.cage} -m last -s -- ${_ oldNixpkgs.gtkgreet} --layer-shell";
          user = "greeter";
        };
      };
    };
  };
}
