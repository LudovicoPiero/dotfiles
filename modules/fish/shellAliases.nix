{
  pkgs,
  lib,
  config,
  ...
}:
let
  _ = lib.getExe;
in
with pkgs;
{
  programs.fish.shellAliases = {
    "cat" = "${_ bat}";
    "config" = "cd ~/Code/nixos";

    "dla" =
      "${_ yt-dlp} --extract-audio --audio-format mp3 --audio-quality 0 -P '/home/${config.vars.username}/Media/Audios'"; # Download Audio
    "dlv" = "${_ yt-dlp} --format 'best[ext=mp4]' -P '/home/${config.vars.username}/Media/Videos'"; # Download Video

    "ls" = "${_ lsd}";
    "l" = "${_ lsd} -lF --git";
    "la" = "${_ lsd} -la --git";
    "ll" = "${_ lsd} --git";
    "llm" = "${_ lsd} -lGF --git --sort=time";
    "t" = "${_ lsd} --tree";
    "tree" = "${_ lsd} --tree";
    "nr" = "${_ nixpkgs-review}";
    "nv" = "nvim";
    "mkdir" = "mkdir -p";
    "g" = "git";
    "gcl" = "git clone";
    "gcm" = "cz c";
    "gd" = "git diff HEAD";
    "gpl" = "git pull";
    "gpsh" = "git push -u origin";
    "gs" = "git status";

    "record" =
      "${_ wl-screenrec} -f /home/${config.vars.username}/Videos/Record/$(date '+%s').mp4";
    "record-region" =
      ''${_ wl-screenrec} -g "$(${_ slurp})" -f /home/${config.vars.username}/Videos/Record/$(date '+%s').mp4'';

    "..." = "cd ../..";
    ".." = "cd ..";
  };
}
