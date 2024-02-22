{ pkgs, lib, ... }:
let
  _ = lib.getExe;
  __ = lib.getExe';
in
with pkgs;
{
  gitignore = "curl -sL https://www.gitignore.io/api/$argv";
  fish_greeting = ""; # disable welcome text

  bs = ''
    pushd ~/Media/nixos
    nh os switch .
      if test $status -eq 0
        notify-send "Rebuild Switch" "Build successful!"
      else
        notify-send "Rebuild Switch" "Build failed!"
      end
    popd
  '';

  bb = ''
    pushd ~/Media/nixos
    nh os boot .
      if test $status -eq 0
        notify-send "Rebuild Boot" "Build successful!"
      else
        notify-send "Rebuild Boot" "Build failed!"
      end
    popd
  '';

  ex = ''
    if test -f $argv[1]
        switch $argv[1]
            case *.tar.bz2
                ${_ gnutar} xjf $argv[1]
                ;;
            case *.tar.gz
                ${_ gnutar} xzf $argv[1]
                ;;
            case *.tar.xz
                ${_ gnutar} xJf $argv[1]
                ;;
            case *.bz2
                ${__ bzip2 "bunzip2"} $argv[1]
                ;;
            case *.rar
                ${_ unrar} x $argv[1]
                ;;
            case *.gz
                ${__ gzip "gunzip"} $argv[1]
                ;;
            case *.tar
                ${_ gnutar} xf $argv[1]
                ;;
            case *.tbz2
                ${_ gnutar} xjf $argv[1]
                ;;
            case *.tgz
                ${_ gnutar} xzf $argv[1]
                ;;
            case *.zip
                ${__ unzip "unzip"} $argv[1]
                ;;
            case *.Z
                ${__ gzip "uncompress"} $argv[1]
                ;;
            case *.7z
                ${__ p7zip "7z"} x $argv[1]
                ;;
            case '*'
                echo "'$argv[1]' cannot be extracted via ex()"
                ;;
        end
    else
        echo "'$argv[1]' is not a valid file"
    end
  '';

  hs = ''
    pushd ~/Media/nixos
    nh home switch .
      if test $status -eq 0
        notify-send "Home-Manager Switch" "Build successful!"
      else
        notify-send "Home-Manager Switch" "Build failed!"
      end
    popd
  '';

  fe = ''
    set selected_file (${lib.getExe' ripgrep "rg"} --files $argv[1] | fzf --preview "${_ bat} -f {}")
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

  run = "nix run nixpkgs#$argv[1] -- $argv[2..-1]";

  "watchLive" =
    let
      args = "--hwdec=dxva2 --gpu-context=d3d11 --no-keepaspect-window --keep-open=no --force-window=yes --force-seekable=yes --hr-seek=yes --hr-seek-framedrop=yes";
    in
    ''${_ streamlink} --player ${_ mpv} --twitch-disable-hosting --twitch-low-latency --player-args "${args}" --player-continuous-http --player-no-close --hls-live-edge 2 --stream-segment-threads 2 --retry-open 15 --retry-streams 15 $argv'';
}
