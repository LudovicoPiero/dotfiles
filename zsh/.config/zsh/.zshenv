# XDG and Clean Home
export ZDOTDIR="$HOME/.config/zsh"
export GNUPGHOME="$HOME/.config/gnupg"
# export LESSHISTFILE="-"
export WGETRC="$HOME/.config/wget/wgetrc"

# Standard Environment
export EDITOR=nvim
export GPG_TTY=$(tty)

# Path Configuration
typeset -U path PATH # Prevent duplicate entries
path=("$HOME/.local/bin" "$HOME/.config/emacs/bin" $path)
export PATH
