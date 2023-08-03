{
  pkgs,
  lib,
  ...
}: let
  _ = lib.getExe;
in
  with pkgs; {
    home.packages = [zoxide fzf fd bat lazygit];

    programs.exa = {
      enable = true;
      enableAliases = false;
    };

    programs.fish = {
      enable = true;

      functions = {
        gitignore = "curl -sL https://www.gitignore.io/api/$argv";
        fish_greeting = ""; # disable welcome text
        run = "nix run nixpkgs#$argv[1] -- $argv[2..-1]";
        "watchLive" = let
          args = "--hwdec=dxva2 --gpu-context=d3d11 --no-keepaspect-window --keep-open=no --force-window=yes --force-seekable=yes --hr-seek=yes --hr-seek-framedrop=yes";
        in "${_ streamlink} --player ${_ mpv} --twitch-disable-hosting --twitch-low-latency --player-args \"${args}\" --player-continuous-http --player-no-close --hls-live-edge 2 --stream-segment-threads 2 --retry-open 15 --retry-streams 15 $argv best -a --ontop -a --no-border";
      };

      interactiveShellInit = ''
        ${_ starship} init fish | source
        ${_ any-nix-shell} fish --info-right | source
        ${_ zoxide} init fish | source
        ${_ direnv} hook fish | source
      '';

      shellAliases = {
        "bs" = "pushd ~/.config/nixos && nixos-rebuild switch --flake .# --use-remote-sudo ; popd";
        "bb" = "pushd ~/.config/nixos && nixos-rebuild boot --flake .# --use-remote-sudo   ; popd";
        "hs" = "pushd ~/.config/nixos && home-manager switch --flake .# --use-remote-sudo  ; popd";
        "cat" = "${_ bat}";
        "config" = "cd ~/.config/nixos";
        "lg" = "lazygit";
        "ls" = "${_ exa} --icons";
        "l" = "${_ exa} -lbF --git --icons";
        "ll" = "${_ exa} -lbGF --git --icons";
        "llm" = "${_ exa} -lbGF --git --sort=modified --icons";
        "la" = "${_ exa} -lbhHigUmuSa --time-style=long-iso --git --color-scale --icons";
        "lx" = "${_ exa} -lbhHigUmuSa@ --time-style=long-iso --git --color-scale --icons";
        "tree" = "${_ exa} --tree --icons";
        "nv" = "nvim";
        "mkdir" = "mkdir -p";
        "g" = "git";
        "..." = "cd ../..";
        ".." = "cd ..";
      };

      plugins = []; #TODO: add plugins
    };

    programs.man.generateCaches = true; # For fish completions
  }
