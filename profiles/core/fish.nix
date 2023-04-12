{
  config,
  pkgs,
  lib,
  ...
}: let
  _ = lib.getExe;
in {
  programs = {
    fish.enable = true; # This settings comes from nixos options
  };
  programs.command-not-found.enable = false;
  home-manager.users."${config.vars.username}" = {
    programs.nix-index.enable = true;
    home.packages = with pkgs; [commitizen zoxide exa fzf fd bat lazygit];
    programs.fish = {
      enable = true;
      functions = {
        gitignore = "curl -sL https://www.gitignore.io/api/$argv";
        fish_greeting = ""; # disable welcome text
        run = "nix run nixpkgs#$argv";
        "watchLive" = let
          args = "--hwdec=dxva2 --gpu-context=d3d11 --no-keepaspect-window --keep-open=no --force-window=yes --force-seekable=yes --hr-seek=yes --hr-seek-framedrop=yes";
        in "${lib.getExe pkgs.streamlink} --player ${lib.getExe pkgs.mpv} --twitch-disable-hosting --twitch-low-latency --player-args \"${args}\" --player-continuous-http --player-no-close --hls-live-edge 2 --hls-segment-threads 2 --retry-open 60 --retry-streams 60 $argv best -a --ontop -a --no-border";
      };
      interactiveShellInit = with pkgs; ''
        ${_ starship} init fish | source
        ${_ any-nix-shell} fish --info-right | source
        ${_ zoxide} init fish | source
        ${_ direnv} hook fish | source
      '';
      shellAliases = with pkgs; {
        "bs" = "pushd ~/.config/nixos && doas nixos-rebuild switch --flake ~/.config/nixos && popd";
        "bb" = "pushd ~/.config/nixos && doas nixos-rebuild boot --flake ~/.config/nixos && popd";
        "hs" = "pushd ~/.config/nixos && home-manager switch --flake ~/.config/nixos && popd";
        "cat" = lib.getExe bat;
        "config" = "cd ~/.config/nixos";
        "lg" = "lazygit";
        "ls" = "exa --icons";
        "l" = "exa -lbF --git --icons";
        "ll" = "exa -lbGF --git --icons";
        "llm" = "exa -lbGF --git --sort=modified --icons";
        "la" = "exa -lbhHigUmuSa --time-style=long-iso --git --color-scale --icons";
        "lx" = "exa -lbhHigUmuSa@ --time-style=long-iso --git --color-scale --icons";
        "tree" = "exa --tree --icons";
        "nv" = "nvim";
        "mkdir" = "mkdir -p";
        "g" = "git";
        "gcl" = "git clone";
        "gcm" = "cz c";
        "gd" = "git diff HEAD";
        "gpl" = "git pull";
        "gpsh" = "git push -u origin";
        "gs" = "git status";
        "sudo" = "doas";
        "..." = "cd ../..";
        ".." = "cd ..";
      };
      plugins = []; #TODO: add plugins
    };
    programs.man.generateCaches = true; # For fish completions
  };
}
