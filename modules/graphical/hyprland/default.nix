{
  config,
  lib,
  pkgs,
  inputs,
  userName,
  ...
}@args:
let
  cfg = config.mine.hyprland;
  inherit (lib) mkIf mkOption types;
in
{
  options.mine.hyprland = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Enable hyprland and set configuration.
      '';
    };
  };

  config = mkIf cfg.enable {
    home-manager.users.${userName} = {
      wayland.windowManager.hyprland = {
        enable = true;
        package = inputs.hyprland.packages.${pkgs.system}.hyprland;
        settings = import ./settings.nix args;
      };
    };
  };
}
