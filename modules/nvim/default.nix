{
  lib,
  pkgs,
  config,
  inputs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.mine.nvim;
in
{
  options.mine.nvim = {
    enable = mkEnableOption "nvim";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [
      inputs.ludovico-nixvim.packages.${pkgs.stdenv.hostPlatform.system}.nvim
    ];

    hj.rum.programs.fish.earlyConfigFiles.nvim = ''
      alias v=nvim
      alias nv=nvim
    '';
  };
}
