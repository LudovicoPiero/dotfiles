{
  lib,
  pkgs,
  config,
  inputs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.myOptions.nvim;
in
{
  options.myOptions.nvim = {
    enable = mkEnableOption "nvim" // {
      default = true;
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [
      inputs.ludovico-nixvim.packages.${pkgs.stdenv.hostPlatform.system}.nvim
    ];
    home-manager.users.${config.vars.username} = {
      programs.fish.shellAliases = {
        v = "nvim";
      };
    }; # For Home-Manager options
  };
}
