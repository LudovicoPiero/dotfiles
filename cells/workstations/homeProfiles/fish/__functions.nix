{
  lib,
  pkgs,
  config,
  ...
}:
let
  _ = lib.getExe;
  __ = lib.getExe';
  nh = pkgs.nh;
in
with pkgs;
{
  gitignore = "curl -sL https://www.gitignore.io/api/$argv";
  fish_greeting = ""; # disable welcome text
  run = "${_ nh} run nixpkgs#$argv[1] -- $argv[2..-1]";

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

  # "watchLive" =
  #   let
  #     args = "--hwdec=dxva2 --gpu-context=d3d11 --no-keepaspect-window --keep-open=no --force-window=yes --force-seekable=yes --hr-seek=yes --hr-seek-framedrop=yes";
  #   in
  #   ''${_ streamlink} --player ${_ mpv} --twitch-disable-hosting --twitch-low-latency --player-args "${args}" --player-continuous-http --player-no-close --hls-live-edge 2 --stream-segment-threads 2 --retry-open 15 --retry-streams 15 $argv'';
}
