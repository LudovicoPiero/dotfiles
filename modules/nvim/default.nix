{
  lib,
  pkgs,
  config,
  inputs,
  ...
}: let
  inherit
    (lib)
    mkEnableOption
    mkIf
    mkOption
    types
    ;

  cfg = config.myOptions.nvim;
in {
  options.myOptions.nvim = {
    enable =
      mkEnableOption "nvim"
      // {
        default = true;
      };
  };

  config = mkIf cfg.enable {
    home-manager.users.${config.myOptions.vars.username} = {
      home.packages = [inputs.ludovico-nixvim.packages.${pkgs.stdenv.hostPlatform.system}.nvim];
      programs.fish.shellAliases = {
        v = "nvim";
      };
    }; # For Home-Manager options
  };
}
