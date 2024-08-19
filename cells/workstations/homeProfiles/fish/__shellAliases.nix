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
  "ls" = "${_ lsd} --icons";
  "l" = "${_ lsd} -lbF --git --icons";
  "ll" = "${_ lsd} -lbGF --git --icons";
  "llm" = "${_ lsd} -lbGF --git --sort=modified --icons";
  "la" = "${_ lsd} -lbhHigUmuSa --time-style=long-iso --git --icons";
  "lx" = "${_ lsd} -lbhHigUmuSa@ --time-style=long-iso --git --icons";
  "t" = "${_ lsd} --tree --icons";
  "tree" = "${_ lsd} --tree --icons";
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
