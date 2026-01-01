# Basic Options
HISTFILE="$ZDOTDIR/.zsh_history"
HISTSIZE=10000
SAVEHIST=10000
setopt APPEND_HISTORY
setopt INC_APPEND_HISTORY
setopt AUTO_CD
unsetopt BEEP

# Fish-like Keybindings
bindkey -e

# Adjust word style to behave like Fish (stop at slashes)
autoload -U select-word-style
select-word-style bash

# Initialize completion system
autoload -Uz compinit
compinit

# Enable interactive menu selection (Fish-style)
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

# Initialize Colors for Completions
# (Requires 'dircolors' to be installed, usually part of coreutils)
if [[ -z "$LS_COLORS" ]]; then
  (( $+commands[dircolors] )) && eval "$(dircolors -b)"
fi
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

# Key Mappings
bindkey '^[^?' backward-kill-word      # Alt-Backspace
bindkey '^[^H' backward-kill-word      # Ctrl-Alt-H
bindkey '^H' backward-kill-word        # Ctrl-Backspace
bindkey '^[[3;3~' kill-word            # Alt-Delete
bindkey '^[[3;5~' kill-word            # Ctrl-Delete

# --- Fish-like history search ---
autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey "^[[A" up-line-or-beginning-search
bindkey "^[[B" down-line-or-beginning-search

# Aliases
alias c='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
alias i='sudo xbps-install'
alias ls="eza --icons=always"
alias l="eza --icons=always -lF --git"
alias la="eza --icons=always -la --git"
alias ll="eza --icons=always --git"
alias llm="eza --icons=always -lGF --git --sort=time"
alias t="eza --icons=always --tree"
alias tree="eza --icons=always --tree"
alias nv="nvim"
alias v="nvim"
alias mkdir="mkdir -p"
alias g="git"
alias x="startx ~/.xinitrc"
alias ..="cd .."
alias ...="cd ../.."

# Force 'i' to use xbps-install completions
compdef i=xbps-install

# GPG Agent
export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
gpgconf --launch gpg-agent

# Initializations
if (( $+commands[zoxide] )); then
  eval "$(zoxide init zsh)"
fi

if (( $+commands[starship] )); then
  eval "$(starship init zsh)"
fi

# FZF Integration
export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border'
if [ -d /usr/share/fzf ]; then
    source /usr/share/fzf/completion.zsh
    source /usr/share/fzf/key-bindings.zsh
fi

# Load Plugins
if [ -d /usr/share/zsh ]; then
    source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
    source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi
