{
  pkgs,
  lib,
  config,
  osConfig,
  ...
}:
let
  _ = lib.getExe;
  __ = lib.getExe';
in
with pkgs;
{
  programs.fish.functions = {
    gitignore = "curl -sL https://www.gitignore.io/api/$argv";
    fish_greeting = ""; # disable welcome text
    run = "${_ osConfig.nix.package} run nixpkgs#$argv[1] -- $argv[2..-1]";
    "," = "nix run nixpkgs#$argv[1]";
    ns = "nix shell nixpkgs#$argv[1]";

    bs = ''
      pushd ${config.home.homeDirectory}/Code/nixos
      ${_ nh} os switch .

      if test $status -eq 0
        ${__ libnotify "notify-send"} "Rebuild Switch" "Build successful!"
      else
        ${__ libnotify "notify-send"} "Rebuild Switch" "Build failed!"
      end

      popd
    '';

    bb = ''
      pushd ${config.home.homeDirectory}/Code/nixos
      ${_ nh} os boot .

      if test $status -eq 0
        ${__ libnotify "notify-send"} "Rebuild Boot" "Build successful!"
      else
        ${__ libnotify "notify-send"} "Rebuild Boot" "Build failed!"
      end

      popd
    '';

    clean-all = ''
      ${_ nh} clean all

      if test $status -eq 0
        ${__ libnotify "notify-send"} "NH Clean All" "Clean successful!"
      else
        ${__ libnotify "notify-send"} "NH Clean All" "Clean failed!"
      end
    '';

    hs = ''
      pushd ${config.home.homeDirectory}/Code/nixos
      ${_ nh} home switch .

      if test $status -eq 0
        ${__ libnotify "notify-send"} "Home-Manager Switch" "Build successful!"
      else
        ${__ libnotify "notify-send"} "Home-Manager Switch" "Build failed!"
      end

      popd
    '';

    fe = ''
      set selected_file (${__ ripgrep "rg"} --files $argv[1] | fzf --preview "${_ bat} -f {}")
      if [ -n "$selected_file" ]
          echo "$selected_file" | xargs $EDITOR
      end
    '';

    paste = ''
      # https://github.com/ptr1337/dotfiles/blob/master/scripts/misc/paste-cachyos
      set URL "https://paste.cachyos.org"

      set FILEPATH $argv[1]
      set FILENAME (basename -- $FILEPATH)
      set EXTENSION (string match -r '\.(.*)$' $FILENAME; and echo $argv[1] ; or echo "")

      set RESPONSE (curl --data-binary @$FILEPATH --url $URL)
      set PASTELINK "$URL$RESPONSE"

      if test -z "$EXTENSION"
          echo "$PASTELINK"
      else
          echo "$PASTELINK$EXTENSION"
      end
    '';

    "watchLive" = ''
      if test (count $argv) -ge 2
          set quality $argv[2]
      else
          set quality "best"
      end

      ${_ streamlink} --player ${_ mpv} $argv[1] $quality
    '';

    "mkcd" = ''
      ${__ uutils-coreutils-noprefix "mkdir"} -p $argv[1]
      if test -d "$argv[1]"
          cd $argv[1]
      end
    '';

    extract = ''
      switch "$argv[1]"
          case '*.tar.bz2'
              ${__ gnutar "tar"} xvjf "$argv[1]"
          case '*.tar.gz'
              ${__ gnutar "tar"} xvzf "$argv[1]"
          case '*.bz2'
              ${__ bzip2 "bunzip2"} "$argv[1]"
          case '*.rar'
              ${_ unrar} x "$argv[1]"
          case '*.gz'
              ${__ gzip "gunzip"} "$argv[1]"
          case '*.tar'
              ${__ gnutar "tar"} xvf "$argv[1]"
          case '*.tbz2'
              ${__ gnutar "tar"} xvjf "$argv[1]"
          case '*.tgz'
              ${__ gnutar "tar"} xvzf "$argv[1]"
          case '*.zip'
              ${_ unzip} "$argv[1]"
          case '*.Z'
              ${__ gzip "uncompress"} "$argv[1]"
          case '*.7z'
              ${__ p7zip "7z"} x "$argv[1]"
          case '*'
              echo "Cannot extract '$argv[1]' via extract"
      end
    '';
  };
}
