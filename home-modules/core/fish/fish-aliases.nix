{
  config,
  pkgs,
  lib,
  ...
}: let
  _ = lib.getExe;
in
  with pkgs; {
    "cat" = "${_ bat}";
    "config" = "cd ~/Media/nixos";
    "dla" = "${_ yt-dlp} --extract-audio --audio-format mp3 --audio-quality 0 -P '${config.home.homeDirectory}/Media/Audios'"; # Download Audio
    "dlv" = "${_ yt-dlp} --format 'best[ext=mp4]' -P '${config.home.homeDirectory}/Media/Videos'"; # Download Video
    "ls" = "${_ lsd}";
    "ll" = "${_ lsd} -l";
    "la" = "${_ lsd} -A";
    "lt" = "${_ lsd} --tree";
    "lla" = "${_ lsd} -lA";
    "t" = "${_ lsd} -l --tree";
    "tree" = "${_ lsd} -l --tree";
    "lg" = "${_ lazygit}";
    "nb" = "nix-build -E 'with import <nixpkgs> { }; callPackage ./default.nix { }'";
    "nv" = "nvim";
    "nr" = "${_ nixpkgs-review}";
    "mkdir" = "mkdir -p";
    # "sudo" = "doas";
    "g" = "git";
    "v" = "vim";
    "record" = "${_ wl-screenrec} -f ${config.xdg.userDirs.extraConfig.XDG_RECORD_DIR}/$(date '+%s').mp4";
    "record-region" = ''${_ wl-screenrec} -g "$(${_ slurp})" -f ${config.xdg.userDirs.extraConfig.XDG_RECORD_DIR}/$(date '+%s').mp4'';
    "y" = "${_ yazi}";
    "..." = "cd ../..";
    ".." = "cd ..";
  }
