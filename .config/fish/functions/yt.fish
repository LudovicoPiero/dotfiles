function yt
    set -l sub $argv[1]
    set -e argv[1]
    set -l base_dir "$HOME/Media"

    switch $sub
      case aac
        yt-dlp --extract-audio --audio-format aac --audio-quality 0 -P "$base_dir/Audios" --output "%(title)s.%(ext)s" $argv
      case best
        yt-dlp --extract-audio --audio-format best --audio-quality 0 -P "$base_dir/Audios" --output "%(title)s.%(ext)s" $argv
      case flac
        yt-dlp --extract-audio --audio-format flac --audio-quality 0 -P "$base_dir/Audios" --output "%(title)s.%(ext)s" $argv
      case mp3
        yt-dlp --extract-audio --audio-format mp3 --audio-quality 0 -P "$base_dir/Audios" --output "%(title)s.%(ext)s" $argv
      case video
        yt-dlp -f 'bestvideo[ext=mp4]+bestaudio[ext=m4a]/bestvideo+bestaudio' \
          --merge-output-format mp4 -P "$base_dir/Videos" --output "%(title)s.%(ext)s" $argv
      case '*'
        echo "Usage: yt [aac|best|flac|mp3|video] <url>"
    end
end
