{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    mkOption
    types
    mkIf
    ;
  cfg = config.mine.tmux;
in
{
  options.mine.tmux = {
    enable = mkEnableOption "Tmux configuration";
    package = mkOption {
      type = types.package;
      default = pkgs.tmux;
      description = "The tmux package to install.";
    };
  };

  config = mkIf cfg.enable {
    hj.packages = [ cfg.package ];

    hj.xdg.config.files."tmux/tmux.conf".text = ''
      set -g prefix C-a
      unbind C-b
      bind C-a send-prefix

      set-option -g update-environment "DISPLAY WAYLAND_DISPLAY NIRI_SOCKET XDG_CURRENT_DESKTOP"
      set -s set-clipboard external

      # setw -g mode-keys vi
      set -g mouse on
      set -g history-limit 10000
      set -s escape-time 10
      set -g base-index 1
      set -g pane-base-index 1
      set -g default-terminal "tmux-256color"
      set -ga terminal-overrides ",*:RGB"

      # Disable confirmation prompts
      bind x kill-pane
      bind & kill-window

      # Pane Navigation (Vim)
      bind h select-pane -L
      bind j select-pane -D
      bind k select-pane -U
      bind l select-pane -R

      # Pane Resizing
      bind -r H resize-pane -L 5
      bind -r J resize-pane -D 5
      bind -r K resize-pane -U 5
      bind -r L resize-pane -R 5

      # Splits (v = bottom, ; = right)
      bind v split-window -v -c "#{pane_current_path}"
      bind \; split-window -h -c "#{pane_current_path}"

      # Window Management
      bind c new-window
      bind 1 select-window -t 1
      bind 2 select-window -t 2
      bind 3 select-window -t 3
      bind 4 select-window -t 4
      bind 5 select-window -t 5
      bind 6 select-window -t 6
      bind 7 select-window -t 7
      bind 8 select-window -t 8

      # Copy Mode (Vim Style)
      bind [ copy-mode
      bind -T copy-mode-vi v send -X begin-selection
      bind -T copy-mode-vi V send -X select-line
      bind -T copy-mode-vi y send -X copy-selection-and-cancel

      # Reload
      bind r source-file ~/.config/tmux/tmux.conf \; display "Config Reloaded!"

      # Tokyo Night Theme
      # Colors
      set -g mode-style "fg=#7aa2f7,bg=#3b4261"
      set -g message-style "fg=#7aa2f7,bg=#3b4261"
      set -g message-command-style "fg=#7aa2f7,bg=#3b4261"
      set -g pane-border-style "fg=#3b4261"
      set -g pane-active-border-style "fg=#7aa2f7"
      set -g status "on"
      set -g status-justify "left"
      set -g status-style "fg=#7aa2f7,bg=#1a1b26"
      set -g status-left-length "100"
      set -g status-right-length "100"
      set -g status-left-style NONE
      set -g status-right-style NONE

      # Status Bar
      set -g status-left "#[fg=#15161e,bg=#7aa2f7,bold] #S #[fg=#7aa2f7,bg=#1a1b26,nobold,nounderscore,noitalics]"
      set -g status-right "#[fg=#1a1b26,bg=#1a1b26,nobold,nounderscore,noitalics]#[fg=#7aa2f7,bg=#1a1b26] #{?client_prefix,#[fg=#f7768e],}  #[fg=#3b4261,bg=#1a1b26,nobold,nounderscore,noitalics]#[fg=#7aa2f7,bg=#3b4261] %Y-%m-%d  %I:%M %p #[fg=#7aa2f7,bg=#3b4261,nobold,nounderscore,noitalics]#[fg=#15161e,bg=#7aa2f7,bold] #h "

      # Windows
      setw -g window-status-activity-style "underscore,fg=#a9b1d6,bg=#1a1b26"
      setw -g window-status-separator ""
      setw -g window-status-style "NONE,fg=#a9b1d6,bg=#1a1b26"
      setw -g window-status-format "#[fg=#1a1b26,bg=#1a1b26,nobold,nounderscore,noitalics]#[default] #I  #W #F #[fg=#1a1b26,bg=#1a1b26,nobold,nounderscore,noitalics]"
      setw -g window-status-current-format "#[fg=#1a1b26,bg=#3b4261,nobold,nounderscore,noitalics]#[fg=#7aa2f7,bg=#3b4261,bold] #I  #W #F #[fg=#3b4261,bg=#1a1b26,nobold,nounderscore,noitalics]"
    '';
  };
}
