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
    programs.git = {
      enable = true;
      config = {
        user = {
          inherit (config.vars) name email;
          signingKey = "3911DD276CFE779C";
        };

        color.ui = "auto";
        init.defaultBranch = "main";
        gpg.format = "openpgp";
        commit.gpgSign = true;
        format.signOff = true;
        pull.rebase = true;

        alias = {
          # Basic Commands
          a = "add -p";
          br = "branch";
          co = "checkout";
          ci = "commit";
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

    hj.files.".config/git/ignore".text = ''
      # Compiled sources #
      ####################
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
      *.elc

      # Caches #
      ##########
      __pycache__/
      .ccls-cache/
      .sass-cache/

      # Backup and temporary files #
      #############################
      *~
      *.*~
      *.bak
      *.swp
      .*.sw[a-z]
      *.un~
      # Emacs autosaves
      \#*
      .\#*
      # Vim
      .netrwhist
      # Misc
      tmp
      TODO

      # Project artifacts #
      #####################
      *result*
      .direnv
      node_modules

      # Nix #
      #######
      .nix-defexpr/

      # OS-generated files #
      ######################
      .DS_Store
      .DS_Store?
      .CFUserTextEncoding
      .Trash
      .Xauthority
      thumbs.db
      Thumbs.db
      Icon?
    '';
  };
}
