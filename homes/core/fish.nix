{
  pkgs,
  lib,
  config,
  ...
}: let
  _ = lib.getExe;
in
  with pkgs; {
    home.packages = [zoxide fzf fd bat];

    programs.fish = {
      enable = true;

      functions = {
        gitignore = "curl -sL https://www.gitignore.io/api/$argv";
        fish_greeting = ""; # disable welcome text
        bs = ''
          pushd ~/.config/nixos
          nh os switch .
            if test $status -eq 0
              notify-send "Rebuild Switch" "Build successful!"
            else
              notify-send "Rebuild Switch" "Build failed!"
            end
          popd
        '';
        bb = ''
          pushd ~/.config/nixos
          nh os boot .
            if test $status -eq 0
              notify-send "Rebuild Boot" "Build successful!"
            else
              notify-send "Rebuild Boot" "Build failed!"
            end
          popd
        '';
        fe = ''
          set selected_file (rg --files ''$argv[1] | fzf --preview "bat -f {}")

          if [ -n "$selected_file" ]
              echo "$selected_file" | xargs $EDITOR
          end
        '';
        prj = ''
          # Credit to https://www.reddit.com/r/fishshell/comments/152zkrz/
          if not command -q fzf
                  echo >&2 "prj: fzf command not found. Install with your OS package manager."
                  return 1
              end

          # determine the project home
          set -q MY_PROJECTS || set -l MY_PROJECTS ~/Code
          set -l prjfolders (path dirname $MY_PROJECTS/**/.git)

          # use fzf to navigate to a project
          set -l prjlist (string replace $MY_PROJECTS/ "" $prjfolders)
          set -l selection (printf '%s\n' $prjlist | sort | fzf --layout=reverse-list --query="$argv")
          test $status -eq 0 || return $status
          echo "Navigating to '$selection'."
          cd $MY_PROJECTS/$selection
        '';
        run = "nix run nixpkgs#$argv[1] -- $argv[2..-1]";
        "watchLive" = let
          args = "--hwdec=dxva2 --gpu-context=d3d11 --no-keepaspect-window --keep-open=no --force-window=yes --force-seekable=yes --hr-seek=yes --hr-seek-framedrop=yes";
        in "${_ streamlink} --player ${_ mpv} --twitch-disable-hosting --twitch-low-latency --player-args \"${args}\" --player-continuous-http --player-no-close --hls-live-edge 2 --stream-segment-threads 2 --retry-open 15 --retry-streams 15 $argv best -a --ontop -a --no-border";
      };

      interactiveShellInit = ''
        set -g async_prompt_functions _pure_prompt_git
        set pure_symbol_prompt "λ"

        ${_ any-nix-shell} fish --info-right | source
        ${_ zoxide} init fish | source
        ${_ direnv} hook fish | source
      '';

      shellAliases = {
        "cat" = "${_ bat}";
        "config" = "cd ~/.config/nixos";
        "ls" = "${_ eza} --icons";
        "l" = "${_ eza} -lbF --git --icons";
        "ll" = "${_ eza} -lbGF --git --icons";
        "llm" = "${_ eza} -lbGF --git --sort=modified --icons";
        "la" = "${_ eza} -lbhHigUmuSa --time-style=long-iso --git --color-scale --icons";
        "lx" = "${_ eza} -lbhHigUmuSa@ --time-style=long-iso --git --color-scale --icons";
        "t" = "${_ eza} --tree --icons";
        "tree" = "${_ eza} --tree --icons";
        "lg" = "lazygit";
        "nb" = "nix-build -E \'with import <nixpkgs> { }; callPackage ./default.nix { }\'";
        "nv" = "nvim";
        "nr" = "${_ nixpkgs-review}";
        "mkdir" = "mkdir -p";
        "g" = "git";
        "v" = "vim";
        "record" = "${_ wl-screenrec} -f ${config.xdg.userDirs.extraConfig.XDG_RECORD_DIR}/$(date '+%s').mp4";
        "record-region" = "${_ wl-screenrec} -g \"$(${_ slurp})\" -f ${config.xdg.userDirs.extraConfig.XDG_RECORD_DIR}/$(date '+%s').mp4";
        "..." = "cd ../..";
        ".." = "cd ..";
      };

      plugins = [
        {
          name = "pure";
          src = pkgs.fetchFromGitHub {
            owner = "pure-fish";
            repo = "pure";
            rev = "924c1c6a9c88125d8d58f00ffe5816fed57f4d99";
            hash = "sha256-PudanwWHDzA8a5I/+hQtsBT/NTTJN5pcyVfFP4fJjWU=";
          };
        }
        {
          name = "fish-async-prompt";
          src = pkgs.fetchFromGitHub {
            owner = "acomagu";
            repo = "fish-async-prompt";
            rev = "4c732cc043b8dd04e64a169ec6bbf3a9b394819f";
            hash = "sha256-YgqZINmY4nKphlqwHo2B0NfP4nmSxIIuAMUuoftI9Lg=";
          };
        }
      ];
    };

    programs.man.generateCaches = true; # For fish completions
  }
