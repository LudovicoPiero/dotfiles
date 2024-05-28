{
  lib,
  pkgs,
  config,
  ...
}:
let
  _ = lib.getExe;
in
with pkgs;
{
  "c" = "${_ commitizen} c -- -s";
  "cat" = "${_ bat}";
  "config" = "cd ${config.home.homeDirectory}/Code/nixos";
  "dla" = "${_ yt-dlp} --extract-audio --audio-format mp3 --audio-quality 0 -P '${config.home.homeDirectory}/Media/Audios'"; # Download Audio
  "dlv" = "${_ yt-dlp} --format 'best[ext=mp4]' -P '${config.home.homeDirectory}/Media/Videos'"; # Download Video
  "ls" = "${_ eza} --icons";
  "l" = "${_ eza} -lbF --git --icons";
  "ll" = "${_ eza} -lbGF --git --icons";
  "llm" = "${_ eza} -lbGF --git --sort=modified --icons";
  "la" = "${_ eza} -lbhHigUmuSa --time-style=long-iso --git --icons";
  "lx" = "${_ eza} -lbhHigUmuSa@ --time-style=long-iso --git --icons";
  "t" = "${_ eza} --tree --icons";
  "tree" = "${_ eza} --tree --icons";
  "lg" = "${_ lazygit}";
  "nb" = "nix-build -E 'with import <nixpkgs> { }; callPackage ./default.nix { }'";
  "ns" = "nix-shell -p";
  "nv" = "nvim";
  "nr" = "${_ nixpkgs-review}";
  "mkdir" = "mkdir -p";
  "g" = "git";
  "v" = "nvim";
  "record" = "${_ wl-screenrec} -f ${config.xdg.userDirs.extraConfig.XDG_RECORD_DIR}/$(date '+%s').mp4";
  "record-region" = ''${_ wl-screenrec} -g "$(${_ slurp})" -f ${config.xdg.userDirs.extraConfig.XDG_RECORD_DIR}/$(date '+%s').mp4'';
  "y" = "${_ yazi}";
  "..." = "cd ../..";
  ".." = "cd ..";
}
