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
