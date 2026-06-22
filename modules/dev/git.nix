_: {
  hm.programs.git = {
    enable = true;
    signing = {
      key = "3911DD276CFE779C";
      signByDefault = true;
    };

    ignores = [
      "*~"
      "*.swp"
      "*.swo"
      "*.bak"
      ".*.swp"
      ".*.swo"
      ".netrw*"
      "tags"
      ".undo/"
      ".clean"
      "*.o"
      "*.out"
      "*.a"
      "*.so"
      "*.la"
      "*.lo"
      "*.elf"
      "build/"
      "dist/"
      "target/"
      ".DS_Store"
      "Thumbs.db"
      "Desktop.ini"
      "*~"
      "lost+found"
      "cached_layouts"
    ];

    settings = {
      user = {
        name = "Ludovico Piero";
        email = "lewdovico@gnuweeb.org";
      };

      color = {
        ui = "auto";
      };

      init = {
        defaultBranch = "main";
      };

      gpg = {
        format = "openpgp";
      };

      format = {
        signOff = true;
      };

      pull = {
        rebase = true;
      };

      core = {
        excludesFile = "~/.config/git/ignore";
      };

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
}
