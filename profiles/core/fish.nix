{
  config,
  pkgs,
  lib,
  ...
}: let
  _ = lib.getExe;
in {
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
        "g" = "git -s";
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
