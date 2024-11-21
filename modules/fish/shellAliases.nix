{
  pkgs,
  lib,
  ...
}:
let
  _ = lib.getExe;
in
with pkgs;
{
  "bs" = "pushd ~/.config/nixos && doas nixos-rebuild switch --flake ~/.config/nixos && popd";
  "bb" = "pushd ~/.config/nixos && doas nixos-rebuild boot --flake ~/.config/nixos && popd";
  "hs" = "pushd ~/.config/nixos && home-manager switch --flake ~/.config/nixos && popd";
  "cat" = "${_ bat}";
  "config" = "cd ~/.config/nixos";
  "ls" = "${_ lsd}";
  "l" = "${_ lsd} -lF --git";
  "la" = "${_ lsd} -la --git";
  "ll" = "${_ lsd} --git";
  "llm" = "${_ lsd} -lGF --git --sort=time";
  "t" = "${_ lsd} --tree";
  "tree" = "${_ lsd} --tree";
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
}
