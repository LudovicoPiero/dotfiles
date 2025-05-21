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
    hj.rum.programs.fish.earlyConfigFiles.myAliases = ''
      alias c="${_ curlie}"
      alias cat="${_ bat}"
      alias config="cd ~/Code/nixos"

      alias ls="${_ eza} --color=always --group-directories-first --icons"
      alias ll="${_ eza} -la --icons --octal-permissions --group-directories-first"
      alias l="${_ eza} -bGF --header --git --color=always --group-directories-first --icons"
      alias llm="${_ eza} -lbGd --header --git --sort=modified --color=always --group-directories-first --icons"
      alias la="${_ eza} --long --all --group --group-directories-first"
      alias lx="${_ eza} -lbhHigUmuSa@ --time-style=long-iso --git --color-scale --color=always --group-directories-first --icons"
      alias lS="${_ eza} -1 --color=always --group-directories-first --icons"
      alias lt="${_ eza} --tree --level=2 --color=always --group-directories-first --icons"
      alias l.="${_ eza} -a | grep -E '^\.'"
      alias t="${_ eza} --icons --tree"
      alias tree="${_ eza} --icons --tree"

      alias nr="${_ nixpkgs-review}"
      alias nv="nvim"
      alias mkdir="mkdir -p"

      alias g="${_ git}"

      alias ..="cd .."
      alias ...="cd ../.."

      alias grep="grep --color=auto"
      alias f="${_ fzf}"
      alias ff="find . -type f | ${_ fzf}"
      alias rg="${_ ripgrep}"
      alias rgr="${_ repgrep}"
      alias jq="${_ jq}"  # jq if not globally accessible
    '';
  };
}
