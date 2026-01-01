function watchLive
    set quality (count $argv) -ge 2; and echo $argv[2]; or echo "best"
    streamlink --player mpv $argv[1] $quality
end
