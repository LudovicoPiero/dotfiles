# https://github.com/viperML/dotfiles/blob/master/wrappers/default.nix
{inputs, ...}: {
  perSystem = {
    pkgs,
    config,
    ...
  }: let
    eval = inputs.wrapper-manager.lib {
      inherit pkgs;
      modules = [
        ./chrome
      ];
    };
  in {
    inherit (eval.config.build) packages;
  };
}
