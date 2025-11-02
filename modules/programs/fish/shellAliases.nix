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
        alias cu="${_ curlie}"
        alias cat="${_ bat}"
        alias c="cd ~/Code/nixos"
        alias config="cd ~/Code/nixos"
        alias v="nvim"
        alias nv="nvim"

        alias ls="${_ eza} --color=always --group-directories-first --icons"
        alias ll="${_ eza} -la --icons --octal-permissions --group-directories-first"
        alias l="${_ eza} -bGF --header --git --color=always --group-directories-first --icons"
        alias llm="${_ eza} -lbGd --header --git --sort=modified --color=always --group-directories-first --icons"
        alias la="${_ eza} --long --all --group --group-directories-first"
        alias lx="${_ eza} -lbhHigUmuSa@ --time-style=long-iso --git --color-scale --color=always --group-directories-first --icons"
        alias lS="${_ eza} -1 --color=always --group-directories-first --icons"
        alias lt="${_ eza} --tree --level=2 --color=always --group-directories-first --icons"
        alias "l."="${_ eza} -a | grep -E '^\\.'"
        alias t="${_ eza} --icons --tree"
        alias tree="${_ eza} --icons --tree"

        alias nr="${_ nixpkgs-review}"
        alias mkdir="mkdir -p"

        alias ..="cd .."
        alias ...="cd ../.."

        alias grep="grep --color=auto"
        alias f="${_ fzf}"
        alias ff="find . -type f | ${_ fzf}"
        alias rg="${_ ripgrep}"
        alias rgr="${_ repgrep}"
        alias jq="${_ jq}"

        # Git
        alias g="${_ git}"

        # Basic Commands
        alias ga="git add -p"
        alias gbr="git branch"
        alias gco="git checkout"
        alias gci="git commit"
        alias gcob="git checkout -b"
        alias gcl="git clone"
        alias gba="git branch -a"
        alias gbd="git branch -d"
        alias gbD="git branch -D"

        # Fetch & Syncing
        alias gf="git fetch"
        alias gfp="git fetch --prune"
        alias gpl="git pull"
        alias gup="git pull --rebase --autostash"
        alias gp="git push"
        alias gpushf="git push --force-with-lease"

        # Commit & Amend
        alias gc="git commit -s -v"
        alias gca="git commit --amend"
        alias gcan="git commit --amend --no-edit"

        # Restore & Reset
        alias gr="git restore"
        alias grs="git restore --staged"
        alias gsoft="git reset --soft"
        alias ghard="git reset --hard"
        alias gs1ft="git reset --soft HEAD~1"
        alias gh1rd="git reset --hard HEAD~1"

        # Stash
        alias gstsh="git stash"
        alias gstls="git stash list"
        alias gstp="git stash pop"

        # Status
        alias gs="git status"
        alias gst="git status -sb"
        alias gsti="git status --ignored"

        # Diff & Comparison
        alias gd="git diff"
        alias gdc="git diff --cached"
        alias gds="git diff --staged"
        alias gd1="git diff HEAD~1 HEAD"
        alias gd2="git diff HEAD~2 HEAD"
        alias gwdf="git diff --word-diff"

        # Logging
        alias gl="git log --oneline --decorate --graph --all"
        alias glast="git log -1 HEAD"
        alias glg="git log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
        alias gplog="git log --graph --pretty=format:'%C(red)%d%C(reset) %C(yellow)%h%C(reset) %ar %C(green)%aN%C(reset) %s'"
        alias gtlog="git log --stat --since='1 Day Ago' --graph --pretty=oneline --abbrev-commit --date=relative"
        alias grank="git shortlog -sn --no-merges"

        # Bisect
        alias gbis="git bisect"
        alias gbisg="git bisect good"
        alias gbisb="git bisect bad"
        alias gbisr="git bisect reset"

        # Rebase & Cleanup
        alias grba="git rebase --abort"
        alias grbc="git rebase --continue"
        alias grbi="git rebase -i HEAD~5"
        alias gclean="git branch --merged | grep -v '\\*' | xargs -n 1 git branch -d"
        alias gbdm="git branch --merged | grep -v '\\*' | xargs -n 1 git branch -d"
      '';
    };
  };
}
