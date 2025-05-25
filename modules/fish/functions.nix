{
  pkgs,
  lib,
  config,
  ...
}:
let
  _ = lib.getExe;
  __ = lib.getExe';

  cfg = config.mine.fish;
in
with pkgs;
{
  config = lib.mkIf cfg.enable {
    hj.rum.programs.fish.earlyConfigFiles.myFunctions = ''
      function gitignore
          curl -sL https://www.toptal.com/developers/gitignore/api/$argv
      end

      function run
          nix run nixpkgs#$argv[1] -- $argv[2..-1]
      end

      function ,
          nix run nixpkgs#$argv[1]
      end

      function ns
          nix shell nixpkgs#$argv[1]
      end


      function notify
          if set -q DISPLAY || set -q WAYLAND_DISPLAY
              ${__ libnotify "notify-send"} $argv
          end
      end

      function y
          set tmp (mktemp -t "yazi-cwd.XXXXXX")
          ${_ yazi} $argv --cwd-file="$tmp"
          if set cwd (command cat -- "$tmp"); and test -n "$cwd"; and test "$cwd" != "$PWD"
              builtin cd -- "$cwd"
          end
          rm -f -- "$tmp"
      end

      function bs
          pushd ${config.vars.homeDirectory}/Code/nixos
          ${_ nh} os switch .

          if test $status -eq 0
              notify "Rebuild Switch" "Build successful!"
          else
              notify "Rebuild Switch" "Build failed!"
          end

          popd
      end

      function bb
          pushd ${config.vars.homeDirectory}/Code/nixos
          ${_ nh} os boot .

          if test $status -eq 0
              notify "Rebuild Boot" "Build successful!"
          else
              notify "Rebuild Boot" "Build failed!"
          end

          popd
      end

      function clean-all
          ${_ nh} clean all

          if test $status -eq 0
              notify "NH Clean all" "Success!"
          else
              notify "NH Clean all" "Failed!"
          end
      end

      function fe
          set selected_file (${__ ripgrep "rg"} --files $argv[1] | fzf --preview "${_ bat} -f {}")
          if test -n "$selected_file"
              echo "$selected_file" | xargs nvim
          end
      end

      function paste
          set URL "https://paste.cachyos.org"

          set FILEPATH $argv[1]
          set FILENAME (basename -- $FILEPATH)
          set EXTENSION (string match -r '\.(.*)$' $FILENAME; and echo $argv[1]; or echo "")

          set RESPONSE (curl --data-binary @$FILEPATH --url $URL)
          set PASTELINK "$URL$RESPONSE"

          if test -z "$EXTENSION"
              echo "$PASTELINK"
          else
              echo "$PASTELINK$EXTENSION"
          end
      end

      function watchLive
          if test (count $argv) -ge 2
              set quality $argv[2]
          else
              set quality "best"
          end

          ${_ streamlink} --player ${_ mpv} $argv[1] $quality
      end

      function mkcd
          ${__ uutils-coreutils-noprefix "mkdir"} -p $argv[1]
          if test -d "$argv[1]"
              cd $argv[1]
          end
      end

      function extract
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
      end

      # Media Stuff
      # Fullscreen screen recording
      function record
        set -l file ${config.vars.homeDirectory}/Videos/Record/(date +'%F_%H:%M:%S').mp4
        ${_ wl-screenrec} -f $file
      end

      # Region-based screen recording
      function record-region
        set -l region (${_ slurp})
        set -l file ${config.vars.homeDirectory}/Videos/Record/(date +'%F_%H:%M:%S').mp4
        ${_ wl-screenrec} -g $region -f $file
      end

      function yt
        set -l sub $argv[1]
        set -e argv[1]

        switch $sub
          case aac
            set -l outdir ${config.vars.homeDirectory}/Media/Audios
            ${_ yt-dlp} --extract-audio --audio-format aac --audio-quality 0 -P $outdir --output "%(title)s.%(ext)s" $argv

          case best
            set -l outdir ${config.vars.homeDirectory}/Media/Audios
            ${_ yt-dlp} --extract-audio --audio-format best --audio-quality 0 -P $outdir --output "%(title)s.%(ext)s" $argv

          case flac
            set -l outdir ${config.vars.homeDirectory}/Media/Audios
            ${_ yt-dlp} --extract-audio --audio-format flac --audio-quality 0 -P $outdir --output "%(title)s.%(ext)s" $argv

          case mp3
            set -l outdir ${config.vars.homeDirectory}/Media/Audios
            ${_ yt-dlp} --extract-audio --audio-format mp3 --audio-quality 0 -P $outdir --output "%(title)s.%(ext)s" $argv

          case video
            set -l outdir ${config.vars.homeDirectory}/Media/Videos
            ${_ yt-dlp} -f 'bestvideo[ext=mp4]+bestaudio[ext=m4a]/bestvideo+bestaudio' \
              --merge-output-format mp4 -P $outdir --output "%(title)s.%(ext)s" $argv

          case '*'
            echo "Usage: yt [aac|best|flac|mp3|video] <url>"
        end
      end
    '';
  };
}
