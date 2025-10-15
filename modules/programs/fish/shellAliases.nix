{
  config,
  pkgs,
  lib,
  ...
}:
let
  _ = lib.getExe;

  cfg = config.mine.fish;
in
with pkgs;
{
  config = lib.mkIf cfg.enable {
    hm.programs.fish.shellAliases = with pkgs; {
      c = "${_ curlie}";
      cat = "${_ bat}";
      config = "cd ~/Code/nixos";
      v = "nvim";
      nv = "nvim";
      ls = "${_ eza} --color=always --group-directories-first --icons";
      ll = "${_ eza} -la --icons --octal-permissions --group-directories-first";
      l = "${_ eza} -bGF --header --git --color=always --group-directories-first --icons";
      llm = "${_ eza} -lbGd --header --git --sort=modified --color=always --group-directories-first --icons";
      la = "${_ eza} --long --all --group --group-directories-first";
      lx = "${_ eza} -lbhHigUmuSa@ --time-style=long-iso --git --color-scale --color=always --group-directories-first --icons";
      lS = "${_ eza} -1 --color=always --group-directories-first --icons";
      lt = "${_ eza} --tree --level=2 --color=always --group-directories-first --icons";
      "l." = "${_ eza} -a | grep -E '^\\.'";
      t = "${_ eza} --icons --tree";
      tree = "${_ eza} --icons --tree";
      nr = "${_ nixpkgs-review}";
      mkdir = "mkdir -p";
      g = "${_ git}";
      ".." = "cd ..";
      "..." = "cd ../..";
      grep = "grep --color=auto";
      f = "${_ fzf}";
      ff = "find . -type f | ${_ fzf}";
      rg = "${_ ripgrep}";
      rgr = "${_ repgrep}";
      jq = "${_ jq}";
    };
  };
}
