# Environment
set -gx GNUPGHOME $HOME/.config/gnupg
set -gx EDITOR nvim
set -gx PATH $HOME/.local/bin $PATH
set -gx PATH "$PATH:$HOME/.local/bin:"

# GPG
set -gx GPG_TTY (tty)
set -gx SSH_AUTH_SOCK (gpgconf --list-dirs agent-ssh-socket)
gpgconf --launch gpg-agent

# Disable greeting
function fish_greeting
end

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
alias nr="nixpkgs-review"
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
