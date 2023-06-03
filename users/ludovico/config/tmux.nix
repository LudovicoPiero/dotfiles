''
  # More friendly split pane
  bind-key h split-window -h
  bind-key v split-window -v

  set -g base-index 1
  set -g pane-base-index 1
  set-window-option -g pane-base-index 1
  set-option -g renumber-windows on

  unbind C-b
  bind -r "<" swap-window -d -t -1
  bind -r ">" swap-window -d -t +1
  bind c new-window -c
  bind Space last-window
  bind -r C-j resize-pane -D 5
  bind -r C-k resize-pane -U 5
  bind -r C-h resize-pane -L 5
  bind -r C-l resize-pane -R 5
  bind -n M-Left select-pane -L
  bind -n M-Right select-pane -R
  bind -n M-Up select-pane -U
  bind -n M-Down select-pane -D

  # quiet
  set -g visual-activity off
  set -g visual-bell off
  set -g visual-silence off
  setw -g monitor-activity off
  set -g bell-action none

  # Some tweaks to the status line
  set -g status-right "%H:%M"
  set -g window-status-current-style "underscore"

  # If running inside tmux ($TMUX is set), then change the status line to red
  %if #{TMUX}
  set -g status-bg red
  %endif

  # Enable RGB colour if running in xterm(1)
  set-option -sa terminal-overrides ",xterm*:Tc"

  # Change the default $TERM to tmux-256color
  set -g default-terminal "tmux-256color"
''
