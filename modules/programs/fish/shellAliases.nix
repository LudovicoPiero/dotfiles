{
  config,
  pkgs,
  lib,
  ...
}:
let
  _ = lib.getExe;

  cfg = config.mine.fish;
in
with pkgs;
{
  config = lib.mkIf cfg.enable {
    hj.mine.programs.fish = {
      config = lib.mkAfter ''
        alias cat="${_ bat}"
        alias ls="${_ lsd}"
        alias l="${_ lsd} -lF --git"
        alias la="${_ lsd} -la --git"
        alias ll="${_ lsd} --git"
        alias llm="${_ lsd} -lGF --git --sort=time"
        alias t="${_ lsd} --tree"
        alias tree="${_ lsd} --tree"
        alias nr="${_ nixpkgs-review}"
        alias nv="nvim"
        alias mkdir="mkdir -p"

        alias g="${_ git}"

        alias ..="cd .."
        alias ...="cd ../.."
      '';
    };
  };
}
