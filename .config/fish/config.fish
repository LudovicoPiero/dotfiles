# Environment
set -gx GNUPGHOME $HOME/.config/gnupg
set -gx EDITOR nvim
set -gx PATH $HOME/.local/bin $PATH
set -gx PATH "$PATH:$HOME/.local/bin:"

set -gx LESSHISTFILE "-"                   # Don't create ~/.lesshst history files
set -gx WGETRC "$HOME/.config/wget/wgetrc" # Move wget config out of home root

# GPG
set -gx GPG_TTY (tty)
set -gx SSH_AUTH_SOCK (gpgconf --list-dirs agent-ssh-socket)
gpgconf --launch gpg-agent

# Disable greeting
function fish_greeting
end

# Launch Hyprland automatically on TTY1 (Login Shell)
# Check if $DISPLAY is empty (no graphical session) AND
# check if $XDG_VTNR is '1' (the first virtual terminal).
# if test -z "$DISPLAY"; and test "$XDG_VTNR" = 1
#     exec dbus-run-session Hyprland
# end

# Use the old fish behavior
bind alt-backspace backward-kill-word
bind ctrl-alt-h backward-kill-word
bind ctrl-backspace backward-kill-token
bind alt-delete kill-word
bind ctrl-delete kill-token

# Aliases
alias c='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
alias cat="bat"
alias ls="lsd"
alias l="lsd -lF --git"
alias la="lsd -la --git"
alias ll="lsd --git"
alias llm="lsd -lGF --git --sort=time"
alias t="lsd --tree"
alias tree="lsd --tree"
# alias nr="nixpkgs-review"
alias nv="nvim"
alias v="nvim"
alias mkdir="mkdir -p"
alias g="git"
alias ..="cd .."
alias ...="cd ../.."

# Initialization
if type -q zoxide
    zoxide init fish | source
end

if type -q starship
    starship init fish | source
end
