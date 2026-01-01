# Environment
set -gx GNUPGHOME $HOME/.config/gnupg
set -gx EDITOR nvim
fish_add_path /usr/local/bin
fish_add_path $HOME/.local/bin
fish_add_path $HOME/.config/emacs/bin

set -gx LESSHISTFILE "-"                   # Don't create ~/.lesshst history files
set -gx WGETRC "$HOME/.config/wget/wgetrc" # Move wget config out of home root

# GPG
set -gx GPG_TTY (tty)
set -gx SSH_AUTH_SOCK (gpgconf --list-dirs agent-ssh-socket)
gpgconf --launch gpg-agent

# Hydro Prompt
set --global hydro_fetch true
set --global hydro_multiline true
# Tokyo Night Color Scheme for Hydro
set --global hydro_color_pwd 7aa2f7      # Blue
set --global hydro_color_git bb9af7      # Magenta
set --global hydro_color_error f7768e    # Red
set --global hydro_color_prompt 9ece6a   # Green
set --global hydro_color_duration e0af68 # Yellow

# Disable greeting
function fish_greeting
end

# Use the old fish behavior
bind alt-backspace backward-kill-word
bind ctrl-alt-h backward-kill-word
bind ctrl-backspace backward-kill-token
bind alt-delete kill-word
bind ctrl-delete kill-token

# Aliases
alias c='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
alias i='sudo xbps-install'
# alias cat="bat"
alias ls="eza --icons=always"
alias l="eza --icons=always -lF --git"
alias la="eza --icons=always -la --git"
alias ll="eza --icons=always --git"
alias llm="eza --icons=always -lGF --git --sort=time"
alias t="eza --icons=always --tree"
alias tree="eza --icons=always --tree"
# alias nr="nixpkgs-review"
alias nv="nvim"
alias v="nvim"
alias mkdir="mkdir -p"
alias g="git"
alias x="startx ~/.xinitrc"
alias ..="cd .."
alias ...="cd ../.."

# Initialization
if type -q zoxide
    zoxide init fish | source
end
