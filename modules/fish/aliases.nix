{
  config,
  pkgs,
  lib,
  ...
}:
let
  _ = lib.getExe;

  mkAlias = name: value: "alias ${name} \"${value}\"";

  aliases = {
    # Utils
    cu = "${_ pkgs.curlie}";
    cat = "${_ pkgs.bat}";
    c = "cd ~/Code/nixos";
    config = "cd ~/Code/nixos";
    v = "nvim";
    nv = "nvim";
    mkdir = "mkdir -p";
    grep = "grep --color=auto";
    jq = "${_ pkgs.jq}";

    # Eza (LS replacements)
    ls = "${_ pkgs.eza} --color=always --group-directories-first --icons";
    ll = "${_ pkgs.eza} -la --icons --octal-permissions --group-directories-first";
    l = "${_ pkgs.eza} -bGF --header --git --color=always --group-directories-first --icons";
    llm = "${_ pkgs.eza} -lbGd --header --git --sort=modified --color=always --group-directories-first --icons";
    la = "${_ pkgs.eza} --long --all --group --group-directories-first";
    lx = "${_ pkgs.eza} -lbhHigUmuSa@ --time-style=long-iso --git --color-scale --color=always --group-directories-first --icons";
    lS = "${_ pkgs.eza} -1 --color=always --group-directories-first --icons";
    lt = "${_ pkgs.eza} --tree --level=2 --color=always --group-directories-first --icons";
    "l." = "${_ pkgs.eza} -a | grep -E '^\\.'";
    t = "${_ pkgs.eza} --icons --tree";
    tree = "${_ pkgs.eza} --icons --tree";

    # Navigation
    ".." = "cd ..";
    "..." = "cd ../..";

    # Nix
    nr = "${_ pkgs.nixpkgs-review}";

    # Fuzzy Finding
    f = "${_ pkgs.fzf}";
    ff = "find . -type f | ${_ pkgs.fzf}";
    rg = "${_ pkgs.ripgrep}";
    rgr = "${_ pkgs.repgrep}";

    # Git
    g = "${_ pkgs.git}";
    ga = "git add -p";
    gbr = "git branch";
    gco = "git checkout";
    gci = "git commit";
    gcob = "git checkout -b";
    gcl = "git clone";
    gba = "git branch -a";
    gbd = "git branch -d";
    gbD = "git branch -D";
    gf = "git fetch";
    gfp = "git fetch --prune";
    gpl = "git pull";
    gup = "git pull --rebase --autostash";
    gp = "git push";
    gpushf = "git push --force-with-lease";
    gc = "git commit -s -v";
    gca = "git commit --amend";
    gcan = "git commit --amend --no-edit";
    gr = "git restore";
    grs = "git restore --staged";
    gsoft = "git reset --soft";
    ghard = "git reset --hard";
    gs1ft = "git reset --soft HEAD~1";
    gh1rd = "git reset --hard HEAD~1";
    gstsh = "git stash";
    gstls = "git stash list";
    gstp = "git stash pop";
    gs = "git status";
    gst = "git status -sb";
    gsti = "git status --ignored";
    gd = "git diff";
    gdc = "git diff --cached";
    gds = "git diff --staged";
    gd1 = "git diff HEAD~1 HEAD";
    gd2 = "git diff HEAD~2 HEAD";
    gwdf = "git diff --word-diff";
    gl = "git log --oneline --decorate --graph --all";
    glast = "git log -1 HEAD";
    glg = "git log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit";
    gplog = "git log --graph --pretty=format:'%C(red)%d%C(reset) %C(yellow)%h%C(reset) %ar %C(green)%aN%C(reset) %s'";
    gtlog = "git log --stat --since='1 Day Ago' --graph --pretty=oneline --abbrev-commit --date=relative";
    grank = "git shortlog -sn --no-merges";
    gbis = "git bisect";
    gbisg = "git bisect good";
    gbisb = "git bisect bad";
    gbisr = "git bisect reset";
    grba = "git rebase --abort";
    grbc = "git rebase --continue";
    grbi = "git rebase -i HEAD~5";
    gclean = "git branch --merged | grep -v '\\*' | xargs -n 1 git branch -d";
    gbdm = "git branch --merged | grep -v '\\*' | xargs -n 1 git branch -d";
  };
  cfg = config.mine.fish;
in
lib.mkIf cfg.enable {
  hj.xdg.config.files."fish/conf.d/aliases.fish".text =
    lib.concatStringsSep "\n" (lib.mapAttrsToList mkAlias aliases);
}
