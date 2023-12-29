{ config, lib, ... }:
let
  cfg = config.mine.git;
  inherit (lib) mkIf mkOption types;
in
{
  options.mine.git = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Enable git and set configuration.
      '';
    };
  };

  config = mkIf cfg.enable {
    programs.git = {
      enable = true;

      difftastic = {
        enable = true;
        background = "dark";
        color = "always";
        display = "side-by-side";
      };

      userEmail = "lewdovico@gnuweeb.org";
      userName = "Ludovico Piero";

      signing = {
        key = "3911DD276CFE779C";
        signByDefault = true;
      };

      extraConfig = {
        init.defaultBranch = "main";
        merge.conflictstyle = "diff3";
      };

      ignores = [
        "*~"
        "*.swp"
        "*result*"
        ".direnv"
        "node_modules"
        "tmp"
      ];

      aliases = {
        a = "add -p";
        co = "checkout";
        cob = "checkout -b";
        f = "fetch -p";
        c = "commit -s -v";
        cl = "clone";
        ba = "branch -a";
        bd = "branch -d";
        bD = "branch -D";
        d = "diff";
        dc = "diff --cached";
        ds = "diff --staged";
        r = "restore";
        rs = "restore --staged";
        s = "status";
        st = "status -sb";
        p = "push";
        pl = "pull";

        # reset
        soft = "reset --soft";
        hard = "reset --hard";
        s1ft = "soft HEAD~1";
        h1rd = "hard HEAD~1";

        # logging
        lg = "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit";
        plog = "log --graph --pretty='format:%C(red)%d%C(reset) %C(yellow)%h%C(reset) %ar %C(green)%aN%C(reset) %s'";
        tlog = "log --stat --since='1 Day Ago' --graph --pretty=oneline --abbrev-commit --date=relative";
        rank = "shortlog -sn --no-merges";

        # delete merged branches
        bdm = "!git branch --merged | grep -v '*' | xargs -n 1 git branch -d";
      };
    };
  };
}
