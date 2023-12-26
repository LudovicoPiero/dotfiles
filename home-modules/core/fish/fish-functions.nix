{ pkgs, lib, ... }:
let
  _ = lib.getExe;
in
with pkgs; {
  gitignore = "curl -sL https://www.gitignore.io/api/$argv";
  fish_greeting = ""; # disable welcome text

  bs = ''
    pushd ~/.config/nixos
    nh os switch .
      if test $status -eq 0
        notify-send "Rebuild Switch" "Build successful!"
      else
        notify-send "Rebuild Switch" "Build failed!"
      end
    popd
  '';

  bb = ''
    pushd ~/.config/nixos
    nh os boot .
      if test $status -eq 0
        notify-send "Rebuild Boot" "Build successful!"
      else
        notify-send "Rebuild Boot" "Build failed!"
      end
    popd
  '';

  hs = ''
    pushd ~/.config/nixos
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

  run = "nix run nixpkgs#$argv[1] -- $argv[2..-1]";
  "watchLive" =
    let
      args = "--hwdec=dxva2 --gpu-context=d3d11 --no-keepaspect-window --keep-open=no --force-window=yes --force-seekable=yes --hr-seek=yes --hr-seek-framedrop=yes";
    in
    ''${_ streamlink} --player ${_ mpv} --twitch-disable-hosting --twitch-low-latency --player-args "${args}" --player-continuous-http --player-no-close --hls-live-edge 2 --stream-segment-threads 2 --retry-open 15 --retry-streams 15 $argv'';
}
