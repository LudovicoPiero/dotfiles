{pkgs, ...}: {
  programs.tmux = {
    enable = true;

    baseIndex = 1;
    prefix = "C-a";
    terminal = "screen-256color";
    mouse = true;

    extraConfig = ''
      bind -n M-H previous-window
      bind -n M-L next-window

      # Set vi-mode
      set-window-option -g mode-keys vi

      # Open panes in current working directory
      bind ';' split-window -h -c "#{pane_current_path}"
      bind v split-window -v -c "#{pane_current_path}"

      # Dracula Theme
      set -g @dracula-show-location false
      set -g @dracula-network-bandwidth-show-interface false
      set -g @dracula-show-timezone false
      set -g @dracula-show-battery false
      set -g @dracula-show-powerline true
      set -g @dracula-refresh-rate 10

      # for left
      set -g @dracula-show-left-sep 

      # for right symbol (can set any symbol you like as seperator)
      set -g @dracula-show-right-sep 
    '';

    plugins = with pkgs.tmuxPlugins; [
      dracula
      sensible
      vim-tmux-navigator
      {
        plugin = yank;
        extraConfig = ''
          bind-key -T copy-mode-vi v send-keys -X begin-selection
          bind-key -T copy-mode-vi C-v send-keys -X rectangle-toggle
          bind-key -T copy-mode-vi y send-keys -X copy-selection-and-cancel
        '';
      }
    ];
  };
}
