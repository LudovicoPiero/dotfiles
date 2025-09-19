{
  config,
  pkgs,
  lib,
  ...
}:
let
  _ = lib.getExe;
  __ = lib.getExe';

  inherit (lib) mkEnableOption mkIf optionalString;

  cfg = config.mine.zsh;
in
{
  imports = [ ./shellAliases.nix ];

  options.mine.zsh = {
    enable = mkEnableOption "ZSH Shell";
  };

  config = mkIf cfg.enable {
    environment.pathsToLink = [ "/share/zsh" ];
    users.users.root.shell = pkgs.zsh;
    users.users.${config.vars.username}.shell = pkgs.zsh;
    sops.secrets."shells/githubToken" = {
      mode = "0444";
    };
    programs = {
      zsh = {
        enable = true;
        enableCompletion = false;
        autosuggestions.enable = false;
        syntaxHighlighting.enable = false;
        interactiveShellInit = ''
          . ${config.sops.secrets."shells/githubToken".path}
        ''
        + optionalString (!config.vars.withGui && config.vars.isALaptop) ''
          ${pkgs.util-linux}/bin/setterm -blank 1 --powersave on
        '';
      };

      bat = {
        enable = true;
        extraPackages = with pkgs.bat-extras; [
          batdiff
          batman
          prettybat
        ];
        settings = {
          pager = "less";
          theme = "OneHalfDark";
        };
      };
    };

    hm =
      { config, osConfig, ... }:
      {
        home.packages = with pkgs; [
          zoxide
          fzf
          fd
          lazygit
          perl
        ];

        programs = {
          zsh = {
            enable = true;

            autosuggestion.enable = true;
            defaultKeymap = "emacs";
            dotDir = "${config.xdg.configHome}/zsh";
            enableCompletion = true;

            history = {
              size = 10000;
              save = 10000;
              path = "${config.xdg.dataHome}/zsh/history";
              ignoreAllDups = true;
            };

            antidote = {
              enable = true;
              plugins = [
                "sindresorhus/pure"
                "Aloxaf/fzf-tab"
                "zsh-users/zsh-syntax-highlighting"
                "joshskidmore/zsh-fzf-history-search"
                "ohmyzsh/ohmyzsh path:lib/git.zsh"
              ];
            };

            initContent = with pkgs; ''
              eval "$(${_ zoxide} init zsh)"
              ${_ nix-your-shell} zsh | source /dev/stdin

              # Case insensitive completion
              zstyle ':completion:*' matcher-list \
                'm:{a-zA-Z}={A-Za-z} r:|=*' \
                'm:{a-zA-Z}={A-Za-z} l:|=* r:|=*'

              # gitignore
              gitignore() {
                curl -sL "https://www.toptal.com/developers/gitignore/api/$@"
              }

              # , -> shorthand to run nix run
              ,() {
                nix run nixpkgs#"''${1}"
              }

              # ns -> nix shell with multiple pkgs
              ns() {
                pkgs=()
                for pkg in "$@"; do
                  pkgs+=("nixpkgs#''${pkg}")
                done
                nix shell "''${pkgs[@]}"
              }

              # notify
              notify() {
                if [[ -n "$DISPLAY" ]] || [[ -n "$WAYLAND_DISPLAY" ]]; then
                  ${__ libnotify "notify-send"} "$@"
                fi
              }

              # y -> yazi with cwd tracking
              y() {
                tmp cwd
                tmp=$(mktemp -t "yazi-cwd.XXXXXX")
                ${_ yazi} "$@" --cwd-file="$tmp"
                if cwd=$(cat -- "$tmp") && [[ -n "$cwd" ]] && [[ "$cwd" != "$PWD" ]]; then
                  cd -- "$cwd"
                fi
                rm -f -- "$tmp"
              }

              # bs -> build & switch
              bs() {
                pushd "${osConfig.vars.homeDirectory}/Code/nixos" || return
                ${_ nh} os switch .

                if [[ $? -eq 0 ]]; then
                  notify "Rebuild Switch" "Build successful!"
                else
                  notify "Rebuild Switch" "Build failed!"
                fi

                popd || return
              }

              # bb -> build & boot
              bb() {
                pushd "${osConfig.vars.homeDirectory}/Code/nixos" || return
                ${_ nh} os boot .

                if [[ $? -eq 0 ]]; then
                  notify "Rebuild Boot" "Build successful!"
                else
                  notify "Rebuild Boot" "Build failed!"
                fi

                popd || return
              }

              # clean-all
              clean-all() {
                ${_ nh} clean all

                if [[ $? -eq 0 ]]; then
                  notify "NH Clean all" "Success!"
                else
                  notify "NH Clean all" "Failed!"
                fi
              }

              fe() {
                selected_file=$(${__ ripgrep "rg"} --no-heading --line-number "$1" | ${_ fzf} --preview '${_ bat} --style=numbers --color=always {1} --highlight-line {2}' \
                  --delimiter : --with-nth 1,2,3)
                if [[ -n "$selected_file" ]]; then
                  file=$(echo "$selected_file" | cut -d: -f1)
                  line=$(echo "$selected_file" | cut -d: -f2)
                  nvim +"$line" "$file"
                fi
              }

              # paste -> send file to paste service
              paste() {
                URL="https://paste.cachyos.org"

                FILEPATH="$1"
                FILENAME=$(basename -- "$FILEPATH")
                EXTENSION="''${FILENAME##*.}"

                RESPONSE=$(curl --data-binary @''${FILEPATH:-/dev/stdin} --url $URL)
                PASTELINK="$URL$RESPONSE"

                [ -z "$EXTENSION" ] && \
                    echo "$PASTELINK" || \
                    echo "$PASTELINK.$EXTENSION"
              }

              # watchLive -> stream with mpv via streamlink
              watchLive() {
                quality="best"
                if (( $# >= 2 )); then
                  quality="$2"
                fi

                ${_ streamlink} --player ${_ mpv} "$1" "$quality"
              }

              # mkcd -> make directory then cd into it
              mkcd() {
                ${__ uutils-coreutils-noprefix "mkdir"} -p "$1"
                if [[ -d "$1" ]]; then
                  cd "$1" || return
                fi
              }

              # extract -> various archive extractors
              extract() {
                case "$1" in
                  *.tar.bz2) ${__ gnutar "tar"} xvjf "$1" ;;
                  *.tar.gz) ${__ gnutar "tar"} xvzf "$1" ;;
                  *.bz2) ${__ bzip2 "bunzip2"} "$1" ;;
                  *.rar) ${_ unrar} x "$1" ;;
                  *.gz) ${__ gzip "gunzip"} "$1" ;;
                  *.tar) ${__ gnutar "tar"} xvf "$1" ;;
                  *.tbz2) ${__ gnutar "tar"} xvjf "$1" ;;
                  *.tgz) ${__ gnutar "tar"} xvzf "$1" ;;
                  *.zip) ${_ unzip} "$1" ;;
                  *.Z) ${__ gzip "uncompress"} "$1" ;;
                  *.7z) ${__ p7zip "7z"} x "$1" ;;
                  *) echo "Cannot extract '$1' via extract" ;;
                esac
              }

              # record -> fullscreen screen recording
              record() {
                file="${osConfig.vars.homeDirectory}/Videos/Record/$(date +'%F_%H:%M:%S').mp4"
                ${_ wl-screenrec} -f "$file"
              }

              # record-region -> region based screen recording
              record-region() {
                region=$(${_ slurp})
                file="${osConfig.vars.homeDirectory}/Videos/Record/$(date +'%F_%H:%M:%S').mp4"
                ${_ wl-screenrec} -g "$region" -f "$file"
              }

              # yt -> download audio/video via yt-dlp
              yt() {
                sub="$1"
                shift

                case "$sub" in
                  aac)
                    ${_ yt-dlp} --extract-audio --audio-format aac --audio-quality 0 -P "${osConfig.vars.homeDirectory}/Media/Audios" --output "%(title)s.%(ext)s" "$@" ;;
                  best)
                    ${_ yt-dlp} --extract-audio --audio-format best --audio-quality 0 -P "${osConfig.vars.homeDirectory}/Media/Audios" --output "%(title)s.%(ext)s" "$@" ;;
                  flac)
                    ${_ yt-dlp} --extract-audio --audio-format flac --audio-quality 0 -P "${osConfig.vars.homeDirectory}/Media/Audios" --output "%(title)s.%(ext)s" "$@" ;;
                  mp3)
                    ${_ yt-dlp} --extract-audio --audio-format mp3 --audio-quality 0 -P "${osConfig.vars.homeDirectory}/Media/Audios" --output "%(title)s.%(ext)s" "$@" ;;
                  video)
                    ${_ yt-dlp} -f 'bestvideo[ext=mp4]+bestaudio[ext=m4a]/bestvideo+bestaudio' \
                      --merge-output-format mp4 -P "${osConfig.vars.homeDirectory}/Media/Videos" --output "%(title)s.%(ext)s" "$@" ;;
                  *)
                    echo "Usage: yt [aac|best|flac|mp3|video] <url>"
                    ;;
                esac
              }
            '';
          };
        };
      };
  };
}
