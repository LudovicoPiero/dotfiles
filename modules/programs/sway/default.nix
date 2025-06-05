{ lib, config, ... }:
let
  inherit (lib)
    mkEnableOption
    mkIf
    mkOption
    mkMerge
    types
    ;

  cfg = config.mine.sway;
in
{
  imports = [
    ./config.nix
    ./bars.nix
    ./keybindings.nix
    ./window.nix
  ];

  options.mine.sway = {
    enable = mkEnableOption "sway";

    withUWSM = mkOption {
      type = types.bool;
      default = true;
    };
  };

  config = mkIf cfg.enable (mkMerge [
    (mkIf cfg.withUWSM {
      programs.uwsm = {
        enable = true;
        waylandCompositors.sway = {
          binPath = "/etc/profiles/per-user/airi/bin/sway";
          prettyName = "Sway";
          comment = "Sway managed by UWSM";
        };
      };

      environment.sessionVariables = {
        APP2UNIT_SLICES = "a=app-graphical.slice b=background-graphical.slice s=session-graphical.slice";
        APP2UNIT_TYPE = "scope";
      };
    })

    {
      hm = {
        wayland.windowManager.sway = {
          enable = true;
          systemd.enable = true;
        };
      };
    }
  ]);
}
