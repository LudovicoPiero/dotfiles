{
  config,
  pkgs,
  lib,
  ...
}: let
  _ = lib.getExe;
in {
  home-manager.users."${config.vars.username}" = {
    home.packages = with pkgs; [commitizen zoxide exa fzf fd bat ripgrep lazygit];
    programs.fish = {
      enable = true;
      functions = {
        gitignore = "curl -sL https://www.gitignore.io/api/$argv";
        fish_greeting = ""; # disable welcome text
        run = "nix run nixpkgs#$argv";
        gadd = "git add $argv";
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
      plugins = [
        {
          name = "z";
          src = pkgs.fetchFromGitHub {
            owner = "jethrokuan";
            repo = "z";
            rev = "85f863f20f24faf675827fb00f3a4e15c7838d76";
            sha256 = "1kaa0k9d535jnvy8vnyxd869jgs0ky6yg55ac1mxcxm8n0rh2mgq";
          };
        }
        {
          name = "fzf";
          src = pkgs.fetchFromGitHub {
            owner = "PatrickF1";
            repo = "fzf.fish";
            rev = "096dc8fff16cfbf54333fb7a9910758e818e239d";
            sha256 = "183z8f7y8629nc78bc3gm5xgwyn813qvjrws4bx8vda2jchxzlb5";
          };
        }
        #{
        #  name = "pure";
        #  src = pkgs.fetchFromGitHub {
        #    owner = "rafaelrinaldi";
        #    repo = "pure";
        #    rev = "8c1f69d7f499469979cbecc7b7eaefb97cd6f509";
        #    sha256 = "1bnp6124cgf4zb1wngb671d7lc4sapizk9jnaa8mdk594z0xzvf9";
        #  };
        #}
      ];
    };
    programs.man.generateCaches = true; # For fish completions
  };
}
