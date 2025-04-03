{
  lib,
  pkgs,
  config,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.myOptions.git;
in
{
  options.myOptions.git = {
    enable = mkEnableOption "Git" // {
      default = true;
    };
  };

  config = mkIf cfg.enable {
    home-manager.users.${config.vars.username} = {
      programs = {
        git = {
          enable = true;
          package = pkgs.gitFull;

          diff-so-fancy = {
            enable = true;
          };

          userEmail = "${config.vars.email}";
          userName = "Ludovico Piero";

          signing = {
            key = "3911DD276CFE779C";
            signByDefault = true;
          };

          extraConfig = {
            init.defaultBranch = "main";
            merge.conflictstyle = "diff3";
            format.signOff = "yes";
            pull.rebase = true;

            sendemail = {
              smtpencryption = "tls";
              smtpserver = "mail1.gnuweeb.org";
              smtpuser = "${config.vars.email}";
              smtpserverport = 587;
              # smtpPass = ""; #TODO: agenix(?)
            };

            color = {
              ui = true;
              diff-highlight = {
                oldNormal = "red bold";
                oldHighlight = "red bold 52";
                newNormal = "green bold";
                newHighlight = "green bold 22";
              };
              diff = {
                meta = "11";
                frag = "magenta bold";
                func = "146 bold";
                commit = "yellow bold";
                old = "red bold";
                new = "green bold";
                whitespace = "red reverse";
              };
            };
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
            # Basic Commands
            a = "add -p";
            co = "checkout";
            cob = "checkout -b";
            cl = "clone";
            ba = "branch -a"; # List all branches
            bd = "branch -d"; # Delete branch
            bD = "branch -D"; # Force delete branch

            # Fetch & Syncing
            f = "fetch";
            fp = "fetch --prune";
            pl = "pull";
            up = "pull --rebase --autostash";
            p = "push";
            pushf = "push --force-with-lease"; # Safe force push

            # Commit & Amend
            c = "commit -s -v";
            ca = "commit --amend";
            can = "commit --amend --no-edit"; # Amend commit without editing message

            # Restore & Reset
            r = "restore";
            rs = "restore --staged";
            soft = "reset --soft";
            hard = "reset --hard";
            s1ft = "reset --soft HEAD~1"; # Undo last commit (keep changes staged)
            h1rd = "reset --hard HEAD~1"; # Undo last commit (discard changes)

            # Stash
            stsh = "stash";
            stls = "stash list";
            stp = "stash pop";

            # Status
            s = "status";
            st = "status -sb"; # Short status
            sti = "status --ignored"; # Show ignored files

            # Diff & Comparison
            d = "diff";
            dc = "diff --cached";
            ds = "diff --staged";
            d1 = "diff HEAD~1 HEAD"; # Compare last commit
            d2 = "diff HEAD~2 HEAD"; # Compare last two commits
            wdiff = "diff --word-diff"; # Word-based diff

            # Logging
            l = "log --oneline --decorate --graph --all";
            last = "log -1 HEAD"; # Show last commit
            lg = "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit";
            plog = "log --graph --pretty='format:%C(red)%d%C(reset) %C(yellow)%h%C(reset) %ar %C(green)%aN%C(reset) %s'";
            tlog = "log --stat --since='1 Day Ago' --graph --pretty=oneline --abbrev-commit --date=relative";
            rank = "shortlog -sn --no-merges"; # List committers ranked by number of commits

            # Bisect
            bis = "bisect";
            bisg = "bisect good";
            bisb = "bisect bad";
            bisr = "bisect reset";

            # Rebase & Cleanup
            rba = "rebase --abort";
            rbc = "rebase --continue";
            rbi = "rebase -i HEAD~5"; # Interactive rebase last 5 commits
            clean = "!git branch --merged | grep -v '\\*' | xargs -n 1 git branch -d"; # Delete merged branches
            bdm = "!git branch --merged | grep -v '\\*' | xargs -n 1 git branch -d"; # Same as `clean`
          };
        };

        gh = {
          enable = true;
          extensions = with pkgs; [
            gh-dash
            gh-f
            gh-poi
          ];
          settings = {
            git_protocol = "ssh";
            prompt = "enabled";
            aliases = {
              co = "pr checkout";
              pv = "pr view";
            };
          };
        };
      };
    };
  };
}
