{pkgs, ...}: {
  home.packages = with pkgs; [exa fzf fd bat ripgrep lazygit];
  programs.zsh = {
    enable = true;
    enableAutoSuggestions = true;
    enableSyntaxHighlighting = true;
    defaultKeymap = "vicmd";
    dirHashes = {
      config = "$HOME/.config/nixos";
      dl     = "$HOME/Downloads";
      gdl    = "$HOME/gallery-dl";
    };
    history = {
      ignorePatterns = ["rm *" "pkill *"];
    };
    shellAliases = {
      "bs" = "doas nixos-rebuild switch --flake ~/.config/nixos";
      "bb" = "doas nixos-rebuild boot --flake ~/.config/nixos";
      "hs" = "home-manager switch --flake ~/.config/nixos";
      #"hx" = "helix";
      "lg" = "lazygit";
      "ls" = "exa --icons";
      "l" = "exa -lbF --git --icons";
      "ll" = "exa -lbGF --git --icons";
      "llm" = "exa -lbGF --git --sort=modified --icons";
      "la" = "exa -lbhHigUmuSa --time-style=long-iso --git --color-scale --icons";
      "lx" = "exa -lbhHigUmuSa@ --time-style=long-iso --git --color-scale --icons";
      "nv" = "nvim";
      "g" = "git";
      "gcl" = "git clone";
      "gcm" = "cz c";
      "gpl" = "git pull";
      "gpsh" = "git push -u origin";
      "sudo" = "doas";
      "..." = "cd ../..";
      ".." = "cd ..";
    };
    plugins = [
      {
    # will source zsh-autosuggestions.plugin.zsh
    name = "zsh-autosuggestions";
    src = pkgs.fetchFromGitHub {
      owner = "zsh-users";
      repo = "zsh-autosuggestions";
      rev = "v0.4.0";
      sha256 = "0z6i9wjjklb4lvr7zjhbphibsyx51psv50gm07mbb0kj9058j6kc";
    };
  }
  {
    name = "enhancd";
    file = "init.sh";
    src = pkgs.fetchFromGitHub {
      owner = "b4b4r07";
      repo = "enhancd";
      rev = "v2.2.1";
      sha256 = "0iqa9j09fwm6nj5rpip87x3hnvbbz9w9ajgm6wkrd5fls8fn8i5g";
    };
  }
    ];
  };
}
