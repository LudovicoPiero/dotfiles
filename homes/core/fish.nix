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

    programs.lsd = {
      enable = true;
      enableAliases = true;
      settings = {
        icons = {
          separator = "  "; # 2 Spaces
        };
      };
    };

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
        ${_ any-nix-shell} fish --info-right | source
        ${_ zoxide} init fish | source
        ${_ direnv} hook fish | source
      '';

      shellAliases = {
        "cat" = "${_ bat}";
        "config" = "cd ~/.config/nixos";
        "lg" = "lazygit";
        "tree" = "${_ lsd} --tree -l";
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
            rev = "fff46b1257bd2122121d02813740a45903ea8593";
            hash = "sha256-5Rx7ba4OWLnNGL+GVwKlWqy0VQxhBg2MC+HntkgeZn0=";
          };
        }
      ];
    };

    programs.man.generateCaches = true; # For fish completions
  }
