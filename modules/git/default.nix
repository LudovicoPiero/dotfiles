{ lib, config, ... }:
let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.mine.git;
in
{
  options.mine.git = {
    enable = mkEnableOption "Git";
  };

  config = mkIf cfg.enable {
    hj.files.".config/git/ignore".text = ''
      # Compiled source #
      *.o
      *.so
      *.a
      *.la
      *.lo
      *.class
      *.dll
      *.exe
      *.out
      *.pyc
      __pycache__/
      .DS_Store

      # Backup files #
      *~
      *.bak
      *.swp

      *result*
      .direnv
      node_modules
      tmp
      TODO

      # Nix #
      .nix-defexpr/
    '';

    hj.rum.programs = {
      git = {
        enable = true;
        # package = pkgs.gitFull;

        settings = {
          color.ui = true;
          init.defaultBranch = "master";
          format.signoff = "yes";
          pull.rebase = true;
          commit.gpgSign = true;
          gpg.format = "openpgp";
          # tag.gpgsign = true;
          # merge.conflictStyle = "diff3";

          user = {
            email = "${config.vars.email}";
            name = "Ludovico Piero";
            signingkey = "3911DD276CFE779C";
          };

          alias = {
            # Basic Commands
            a = "add -p";
            co = "checkout";
            cob = "checkout -b";
            cl = "clone";
            ba = "branch -a";
            bd = "branch -d";
            bD = "branch -D";

            # Fetch & Syncing
            f = "fetch";
            fp = "fetch --prune";
            pl = "pull";
            up = "pull --rebase --autostash";
            p = "push";
            pushf = "push --force-with-lease";

            # Commit & Amend
            c = "commit -s -v";
            ca = "commit --amend";
            can = "commit --amend --no-edit";

            # Restore & Reset
            r = "restore";
            rs = "restore --staged";
            soft = "reset --soft";
            hard = "reset --hard";
            s1ft = "reset --soft HEAD~1";
            h1rd = "reset --hard HEAD~1";

            # Stash
            stsh = "stash";
            stls = "stash list";
            stp = "stash pop";

            # Status
            s = "status";
            st = "status -sb";
            sti = "status --ignored";

            # Diff & Comparison
            d = "diff";
            dc = "diff --cached";
            ds = "diff --staged";
            d1 = "diff HEAD~1 HEAD";
            d2 = "diff HEAD~2 HEAD";
            wdiff = "diff --word-diff";

            # Logging
            l = "log --oneline --decorate --graph --all";
            last = "log -1 HEAD";
            lg = "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit";
            plog = "log --graph --pretty=format:'%C(red)%d%C(reset) %C(yellow)%h%C(reset) %ar %C(green)%aN%C(reset) %s'";
            tlog = "log --stat --since='1 Day Ago' --graph --pretty=oneline --abbrev-commit --date=relative";
            rank = "shortlog -sn --no-merges";

            # Bisect
            bis = "bisect";
            bisg = "bisect good";
            bisb = "bisect bad";
            bisr = "bisect reset";

            # Rebase & Cleanup
            rba = "rebase --abort";
            rbc = "rebase --continue";
            rbi = "rebase -i HEAD~5";
            clean = "!git branch --merged | grep -v '\\*' | xargs -n 1 git branch -d";
            bdm = "!git branch --merged | grep -v '\\*' | xargs -n 1 git branch -d";
          };
        };
      };
    };
  };
}
