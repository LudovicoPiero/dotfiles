{ lib, pkgs, ... }:
let
  _ = lib.getExe;
  __ = lib.getExe';
in
with pkgs;
{
  programs.zsh.initExtra = ''
    # Enable extended globbing
    setopt extended_glob

    # Enable case-insensitive completion
    zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

    # Enable partial-word completion
    zstyle ':completion:*' completer _complete _match

    # Enable partial-word completion by trying exact matches first, then partial matches
    zstyle ':completion:*' completer _complete _match

    # Define the sequence of completers to use during completion
    zstyle ':completion:*' completer _complete _ignored _approximate

    # Set colors for the completion list using the LS_COLORS environment variable
    zstyle ':completion:*' list-colors ''${(s.:.)LS_COLORS}

    # Customize the prompt displayed above the completion list
    zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s

    # Allow case-insensitive matching during completion
    zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

    # Enable a menu selection interface for completions
    zstyle ':completion:*' menu select

    # Customize the prompt displayed during menu selection
    zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s

    # Provide verbose descriptions for completion options
    zstyle ':completion:*' verbose true

    # Include hidden files (dotfiles) in completion results
    _comp_options+=(globdots)

    # Make Alt+Backspace like fish shell
    WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'
    bindkey '^[?' backward-kill-word

    # direnv integration
    eval "$(${pkgs.direnv}/bin/direnv hook zsh)"

    source "${pkgs.fzf}/share/fzf/key-bindings.zsh"
    ${_ pkgs.nix-your-shell} zsh | source /dev/stdin

    function extract() {
      case "$1" in
        *.tar.bz2)
          ${__ gnutar "tar"} xvjf "$1"
          ;;
        *.tar.gz)
          ${__ gnutar "tar"} xvzf "$1"
          ;;
        *.bz2)
          ${__ bzip2 "bunzip2"} "$1"
          ;;
        *.rar)
          ${_ unrar} x "$1"
          ;;
        *.gz)
          ${__ gzip "gunzip"} "$1"
          ;;
        *.tar)
          ${__ gnutar "tar"} xvf "$1"
          ;;
        *.tbz2)
          ${__ gnutar "tar"} xvjf "$1"
          ;;
        *.tgz)
          ${__ gnutar "tar"} xvzf "$1"
          ;;
        *.zip)
          ${_ unzip} "$1"
          ;;
        *.Z)
          ${__ gzip "uncompress"} "$1"
          ;;
        *.7z)
          ${__ p7zip "7z"} x "$1"
          ;;
        *)
          echo "Cannot extract '$1' via extract"
          ;;
      esac
    }

    function bs() {
      pushd ~/Code/nixos
      ${_ nh} os switch .
        if [[ $? -eq 0 ]]; then
          ${__ libnotify "notify-send"} "Rebuild Switch" "Build successful!"
        else
          ${__ libnotify "notify-send"} "Rebuild Switch" "Build failed!"
        fi
      popd
    }

    function bb() {
      pushd ~/Code/nixos
      ${_ nh} os boot .
        if [[ $? -eq 0 ]]; then
          ${__ libnotify "notify-send"} "Rebuild Boot" "Build successful!"
        else
          ${__ libnotify "notify-send"} "Rebuild Boot" "Build failed!"
        fi
      popd
    }

    function hs() {
      pushd ~/Code/nixos
      ${_ nh} home switch .
        if [[ $? -eq 0 ]]; then
          ${__ libnotify "notify-send"} "Home-Manager Switch" "Build successful!"
        else
          ${__ libnotify "notify-send"} "Home-Manager Switch" "Build failed!"
        fi
      popd
    }

    function fe() {
      selected_file=$(rg --files ''$argv[1] | ${_ fzf} --preview "${_ bat} -f {}")
      if [ -n "$selected_file" ]; then
        echo "$selected_file" | xargs $EDITOR
      fi
    }

    function watchLive() {
      # Use the provided quality if present; otherwise, default to "best"
      local quality
      if (( $# >= 2 )); then
        quality="$2"
      else
        quality="best"
      fi

      ${_ streamlink} --player ${_ mpv} "$1" "$quality"
    }
  '';
}
