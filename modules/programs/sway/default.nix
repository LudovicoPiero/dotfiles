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

      environment = {
        etc."greetd/environments".text = lib.mkAfter "uwsm start sway-uwsm.desktop";
        sessionVariables = {
          APP2UNIT_SLICES = "a=app-graphical.slice b=background-graphical.slice s=session-graphical.slice";
          APP2UNIT_TYPE = "scope";
        };
      };
    })

    {
      hm =
        let
          inherit (config.mine.theme.colorScheme) palette;
          background = palette.base00;
          indicator = palette.base0B;
          text = palette.base05;
          urgent = palette.base08;
          focused = palette.base0D;
          unfocused = palette.base03;
        in
        {
          wayland.windowManager.sway = {
            enable = true;
            systemd.enable = true;
            config.colors = {
              urgent = {
                inherit background indicator text;
                border = urgent;
                childBorder = urgent;
              };
              focused = {
                inherit background indicator text;
                border = focused;
                childBorder = focused;
              };
              focusedInactive = {
                inherit background indicator text;
                border = unfocused;
                childBorder = unfocused;
              };
              unfocused = {
                inherit background indicator text;
                border = unfocused;
                childBorder = unfocused;
              };
              placeholder = {
                inherit background indicator text;
                border = unfocused;
                childBorder = unfocused;
              };
            };
          };
        };
    }
  ]);
}
