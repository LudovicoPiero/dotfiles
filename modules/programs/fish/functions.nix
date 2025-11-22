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
{
  config = lib.mkIf cfg.enable {
    hj.mine.programs.fish.config = lib.mkAfter ''
      function fish_greeting
      end

      function gitignore
          curl -sL https://www.toptal.com/developers/gitignore/api/$argv
      end

      function run
          nix run nixpkgs#$argv[1] -- $argv[2..-1]
      end

      function ,
          if test (count $argv) -eq 0
              echo "Usage: , <package> [args...]"
              return 1
          end
          nix run nixpkgs#$argv[1] -- $argv[2..-1]
      end

      function ns
          if test (count $argv) -eq 0
              echo "Usage: ns <packages...> [--nix-flags...]"
              return 1
          end

          set -l pkgs
          set -l args

          for arg in $argv
              if string match -q -- "-*" $arg
                  set args $args $arg
              else
                  set pkgs $pkgs nixpkgs#$arg
              end
          end

          nix shell $pkgs $args
      end

      function notify
          if set -q DISPLAY || set -q WAYLAND_DISPLAY
              ${__ pkgs.libnotify "notify-send"} $argv
          end
      end

      function y
          set tmp (mktemp -t "yazi-cwd.XXXXXX")
          ${_ pkgs.yazi} $argv --cwd-file="$tmp"
          if set cwd (command cat -- "$tmp"); and test -n "$cwd"; and test "$cwd" != "$PWD"
              builtin cd -- "$cwd"
          end
          rm -f -- "$tmp"
      end

      function bs
          set -l FLAKE_DIR "${config.vars.homeDirectory}/Code/nixos"
          set -l PROFILE "/nix/var/nix/profiles/system"
          set -l CURRENT_SYSTEM "/run/current-system"
          set -l HOST (hostname)

          pushd $FLAKE_DIR
          echo "🔨 Building system closure..."

          # 1. Build the system derivation using nom (creates ./result symlink)
          # nom wraps 'nix build' to provide a pretty dependency graph
          if ${lib.getExe pkgs.nix-output-monitor} build ".#nixosConfigurations.$HOST.config.system.build.toplevel"

              # 2. Preview the diff (Current System vs New Result)
              echo "📊 Previewing changes:"
              ${lib.getExe pkgs.dix} $CURRENT_SYSTEM result/

              read -P "🚀 Apply these changes? [y/N] " confirm

              if string match -qi "y" $confirm
                  echo "🔄 Switching configuration..."

                  # 3. Update the System Profile
                  # Links the new build as the current system generation.
                  sudo nix-env -p $PROFILE --set ./result

                  # 4. Activate the Configuration
                  # Reloads systemd, restarts services, and updates boot entries.
                  if sudo ./result/bin/switch-to-configuration switch
                      ${__ pkgs.libnotify "notify-send"} -u normal "Rebuild Switch" "System switched successfully!"
                  else
                      ${__ pkgs.libnotify "notify-send"} -u critical "Rebuild Switch" "Activation failed!"
                  end
              else
                  echo "❌ Changes discarded."
              end
          else
              ${__ pkgs.libnotify "notify-send"} -u critical "Rebuild Switch" "Build failed!"
          end

          # Cleanup the build symlink
          rm -f result
          popd
      end

      function bb
          set -l FLAKE_DIR "${config.vars.homeDirectory}/Code/nixos"
          set -l PROFILE "/nix/var/nix/profiles/system"
          set -l CURRENT_SYSTEM "/run/current-system"
          set -l HOST (hostname)

          pushd $FLAKE_DIR
          echo "🔨 Building system closure..."

          # 1. Build the system derivation using nom
          if ${lib.getExe pkgs.nix-output-monitor} build ".#nixosConfigurations.$HOST.config.system.build.toplevel"

              # 2. Preview the diff (Current System vs New Result)
              echo "📊 Previewing changes:"
              ${lib.getExe pkgs.dix} $CURRENT_SYSTEM result/

              read -P "🥾 Set this as default boot entry? [y/N] " confirm

              if string match -qi "y" $confirm
                  echo "🔄 Updating bootloader..."

                  # 3. Update the System Profile
                  # Links the new build as the current system generation.
                  sudo nix-env -p $PROFILE --set ./result

                  # 4. Activate the Configuration (Boot)
                  # Only updates the bootloader, does NOT restart services.
                  if sudo ./result/bin/switch-to-configuration boot
                      ${__ pkgs.libnotify "notify-send"} -u normal "Rebuild Boot" "Boot entry updated successfully!"
                  else
                      ${__ pkgs.libnotify "notify-send"} -u critical "Rebuild Boot" "Bootloader update failed!"
                  end
              else
                  echo "❌ Changes discarded."
              end
          else
              ${__ pkgs.libnotify "notify-send"} -u critical "Rebuild Boot" "Build failed!"
          end

          # Cleanup the build symlink
          rm -f result
          popd
      end

      function clean-all
          ${_ pkgs.nh} clean all

          if test $status -eq 0
              ${__ pkgs.libnotify "notify-send"} "NH Clean" "Clean successful!"
          else
              ${__ pkgs.libnotify "notify-send"} -u critical "NH Clean" "Clean failed!"
          end
      end

      function fe
          set pattern (or $argv[1] "")
          set selected_file ( ${__ pkgs.ripgrep "rg"} --no-heading --line-number "$pattern" | \
              ${_ pkgs.fzf} --delimiter : --with-nth 1,2,3 \
                  --preview "${_ pkgs.bat} --style=numbers --color=always {1} --highlight-line {2}" )

          if test -n "$selected_file"
              set file (string split -f1 ":" $selected_file)
              set line (string split -f2 ":" $selected_file)
              nvim +$line $file
          end
      end

      function fef
          set dir (or $argv[1] .)
          set selected_file ( ${__ pkgs.ripgrep "rg"} --files $dir \
              | ${_ pkgs.fzf} --preview "${_ pkgs.bat} --style=numbers --color=always {}" )

          if test -n "$selected_file"
              nvim $selected_file
          end
      end

      function paste
          set URL "https://paste.cachyos.org"
          set FILEPATH $argv[1]
          set RESPONSE (curl --data-binary @$FILEPATH --url $URL)
          echo "$URL$RESPONSE"
      end

      function watchLive
          set quality "best"
          if test (count $argv) -ge 2
              set quality $argv[2]
          end
          ${_ pkgs.streamlink} --player ${_ pkgs.mpv} $argv[1] $quality
      end

      function mkcd
          mkdir -p $argv[1]
          cd $argv[1]
      end

      function extract
          if test -f $argv[1]
              switch $argv[1]
                  case '*.tar.bz2'
                      ${__ pkgs.gnutar "tar"} xvjf $argv[1]
                  case '*.tar.gz'
                      ${__ pkgs.gnutar "tar"} xvzf $argv[1]
                  case '*.bz2'
                      ${__ pkgs.bzip2 "bunzip2"} $argv[1]
                  case '*.rar'
                      ${_ pkgs.unrar} x $argv[1]
                  case '*.gz'
                      ${__ pkgs.gzip "gunzip"} $argv[1]
                  case '*.tar'
                      ${__ pkgs.gnutar "tar"} xvf $argv[1]
                  case '*.tbz2'
                      ${__ pkgs.gnutar "tar"} xvjf $argv[1]
                  case '*.tgz'
                      ${__ pkgs.gnutar "tar"} xvzf $argv[1]
                  case '*.zip'
                      ${_ pkgs.unzip} $argv[1]
                  case '*.Z'
                      ${__ pkgs.gzip "uncompress"} $argv[1]
                  case '*.7z'
                      ${__ pkgs.p7zip "7z"} x $argv[1]
                  case '*'
                      echo "'$argv[1]' cannot be extracted via extract()"
              end
          else
              echo "'$argv[1]' is not a valid file"
          end
      end

      function record
          set -l file ${config.vars.homeDirectory}/Videos/Record/(date +'%F_%H:%M:%S').mp4
          ${_ pkgs.wl-screenrec} -f $file
      end

      function record-region
          set -l region (${_ pkgs.slurp})
          set -l file ${config.vars.homeDirectory}/Videos/Record/(date +'%F_%H:%M:%S').mp4
          ${_ pkgs.wl-screenrec} -g $region -f $file
      end

      function yt
          set -l sub $argv[1]
          set -e argv[1]
          set -l outdir_audio ${config.vars.homeDirectory}/Media/Audios
          set -l outdir_video ${config.vars.homeDirectory}/Media/Videos

          switch $sub
              case aac
                  ${_ pkgs.yt-dlp} --extract-audio --audio-format aac --audio-quality 0 -P $outdir_audio --output "%(title)s.%(ext)s" $argv
              case best
                  ${_ pkgs.yt-dlp} --extract-audio --audio-format best --audio-quality 0 -P $outdir_audio --output "%(title)s.%(ext)s" $argv
              case flac
                  ${_ pkgs.yt-dlp} --extract-audio --audio-format flac --audio-quality 0 -P $outdir_audio --output "%(title)s.%(ext)s" $argv
              case mp3
                  ${_ pkgs.yt-dlp} --extract-audio --audio-format mp3 --audio-quality 0 -P $outdir_audio --output "%(title)s.%(ext)s" $argv
              case video
                  ${_ pkgs.yt-dlp} -f 'bestvideo[ext=mp4]+bestaudio[ext=m4a]/bestvideo+bestaudio' --merge-output-format mp4 -P $outdir_video --output "%(title)s.%(ext)s" $argv
              case '*'
                  echo "Usage: yt [aac|best|flac|mp3|video] <url>"
          end
      end
    '';
  };
}
