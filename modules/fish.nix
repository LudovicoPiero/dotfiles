{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    getExe
    mkOption
    types
    mkIf
    ;
  cfg = config.mine.fish;
in
{
  options.mine.fish = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable Fish shell configuration.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      fish
      eza
      bat
      zoxide
      fishPlugins.hydro
    ];

    # Enable fish globally so /etc/shells is updated
    programs.fish.enable = true;
    hj = {
      xdg.config.files = {
        "fish/config.fish".text = ''
           # Environment
           set -gx EDITOR nvim
           set -gx LESSHISTFILE "-"                    # Don't create ~/.lesshst
           set -gx WGETRC "$HOME/.config/wget/wgetrc"  # Move wget config

           # Source Plugin directly from Nix store
           set -l hydro_path "${pkgs.fishPlugins.hydro}/share/fish"
           set -p fish_function_path "$hydro_path/vendor_functions.d"
           source "$hydro_path/vendor_conf.d/hydro.fish"

           # Hydro Settings
           set --global hydro_fetch true
           set --global hydro_multiline true
           set --global hydro_color_pwd 7aa2f7      # Blue
           set --global hydro_color_git bb9af7      # Magenta
           set --global hydro_color_error f7768e    # Red
           set --global hydro_color_prompt 9ece6a   # Green
           set --global hydro_color_duration e0af68 # Yellow

           # Disable greeting
           function fish_greeting
           end

           # Key bindings (Old fish behavior)
           bind alt-backspace backward-kill-word
           bind ctrl-alt-h backward-kill-word
           bind ctrl-backspace backward-kill-token
           bind alt-delete kill-word
           bind ctrl-delete kill-token

           # Aliases
           alias cat="${getExe pkgs.bat}"

           # Eza aliases
           alias ls="${getExe pkgs.eza} --icons=always"
           alias l="${getExe pkgs.eza} --icons=always -lF --git"
           alias la="${getExe pkgs.eza} --icons=always -la --git"
           alias ll="${getExe pkgs.eza} --icons=always --git"
           alias llm="${getExe pkgs.eza} --icons=always -lGF --git --sort=time"
           alias t="${getExe pkgs.eza} --icons=always --tree"
           alias tree="${getExe pkgs.eza} --icons=always --tree"

          alias nv="nvim"
          alias v="nvim"
          alias config="cd ~/Code/nixos"
          alias mkdir="mkdir -p"
          alias g="${getExe pkgs.git}"
          alias ..="cd .."
          alias ...="cd ../.."

           # Initialization
           if type -q zoxide
               ${getExe pkgs.zoxide} init fish | source
           end
        '';

        # mkcd: Builtins only
        "fish/functions/mkcd.fish".text = ''
          function mkcd
              mkdir -p $argv[1]
              if test -d "$argv[1]"
                  cd $argv[1]
              end
          end
        '';

        # fe: ripgrep + fzf + bat + nvim
        "fish/functions/fe.fish".text = ''
          function fe
              set pattern $argv[1]
              if test -z "$pattern"
                  echo "Usage: fe <pattern>"
                  return 1
              end

              set selected_file (${getExe pkgs.ripgrep} --hidden --glob '!.git' --no-heading --line-number "$pattern" | \
                  ${getExe pkgs.fzf} --delimiter : --with-nth 1,2,3 \
                  --preview "${getExe pkgs.bat} --style=numbers --color=always {1} --highlight-line {2}" \
                  --preview-window "+{2}/2")

              if test -n "$selected_file"
                  set parts (string split -m 2 ":" $selected_file)
                  set file $parts[1]
                  set line $parts[2]
                  nvim +$line $file
              end
          end
        '';

        # fef: fd + fzf + bat + nvim
        "fish/functions/fef.fish".text = ''
          function fef
              set dir (or $argv[1] .)
              set selected_file (${getExe pkgs.fd} --type f --hidden --follow --exclude .git . $dir | ${getExe pkgs.fzf} --preview "${getExe pkgs.bat} --style=numbers --color=always {}")

              if test -n "$selected_file"
                  nvim $selected_file
              end
          end
        '';

        # y: yazi
        "fish/functions/y.fish".text = ''
          function y
              set tmp (mktemp -t "yazi-cwd.XXXXXX")
              ${getExe pkgs.yazi} $argv --cwd-file="$tmp"
              if set cwd (command cat -- "$tmp"); and test -n "$cwd"; and test "$cwd" != "$PWD"
                  builtin cd -- "$cwd"
              end
              rm -f -- "$tmp"
          end
        '';

        # watchLive: streamlink + mpv
        "fish/functions/watchLive.fish".text = ''
          function watchLive
              set quality (count $argv) -ge 2; and echo $argv[2]; or echo "best"
              ${getExe pkgs.streamlink} --player ${getExe pkgs.mpv} $argv[1] $quality
          end
        '';

        # yt: yt-dlp
        "fish/functions/yt.fish".text = ''
          function yt
              set -l sub $argv[1]
              set -e argv[1]
              set -l base_dir "$HOME/Media"
              set -l ytdlp "${getExe pkgs.yt-dlp}"

              switch $sub
                case aac
                  $ytdlp --extract-audio --audio-format aac --audio-quality 0 -P "$base_dir/Audios" --output "%(title)s.%(ext)s" $argv
                case best
                  $ytdlp --extract-audio --audio-format best --audio-quality 0 -P "$base_dir/Audios" --output "%(title)s.%(ext)s" $argv
                case flac
                  $ytdlp --extract-audio --audio-format flac --audio-quality 0 -P "$base_dir/Audios" --output "%(title)s.%(ext)s" $argv
                case mp3
                  $ytdlp --extract-audio --audio-format mp3 --audio-quality 0 -P "$base_dir/Audios" --output "%(title)s.%(ext)s" $argv
                case video
                  $ytdlp -f 'bestvideo[ext=mp4]+bestaudio[ext=m4a]/bestvideo+bestaudio' \
                    --merge-output-format mp4 -P "$base_dir/Videos" --output "%(title)s.%(ext)s" $argv
                case '*'
                  echo "Usage: yt [aac|best|flac|mp3|video] <url>"
              end
          end
        '';

        # extract: All compression tools
        "fish/functions/extract.fish".text = ''
          function extract
              switch "$argv[1]"
                  case '*.tar.bz2'; tar xvjf "$argv[1]"
                  case '*.tar.gz';  tar xvzf "$argv[1]"
                  case '*.bz2';     bzip2 -d "$argv[1]"
                  case '*.rar';     ${getExe pkgs.unrar} x "$argv[1]"
                  case '*.gz';      gzip -d "$argv[1]"
                  case '*.tar';     tar xvf "$argv[1]"
                  case '*.tbz2';    tar xvjf "$argv[1]"
                  case '*.tgz';     tar xvzf "$argv[1]"
                  case '*.zip';     ${getExe pkgs.unzip} "$argv[1]"
                  case '*.Z';       uncompress "$argv[1]"
                  case '*.7z';      ${getExe pkgs.p7zip} x "$argv[1]"
                  case '*';         echo "Cannot extract '$argv[1]'"
              end
          end
        '';
      };
    };
  };
}
