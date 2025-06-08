{ lib, config, ... }:
let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.mine.tmux;
in
{
  options.mine.tmux = {
    enable = mkEnableOption "tmux";
  };

  config = mkIf cfg.enable {
    hm.programs.tmux = {
      enable = true;
      prefix = "C-a"; # Sets the prefix key to Ctrl+a
      keyMode = "vi"; # Enables vi-style keybindings
      mouse = true; # Enables mouse support
      historyLimit = 10000; # Sets the scrollback buffer size
      escapeTime = 10; # Sets the escape time in milliseconds
      baseIndex = 1; # Sets window and pane numbering to start at 1
      terminal = "screen-256color"; # Sets the terminal type
      resizeAmount = 5; # Sets the pane resize amount
      customPaneNavigationAndResize = true; # Enables custom pane navigation and resizing
      reverseSplit = false; # Keeps default split directions
      disableConfirmationPrompt = true; # Disables confirmation prompts
      extraConfig = ''
        # Pane navigation
        bind h select-pane -L
        bind j select-pane -D
        bind k select-pane -U
        bind l select-pane -R

        # Pane resizing
        bind -r H resize-pane -L 5
        bind -r J resize-pane -D 5
        bind -r K resize-pane -U 5
        bind -r L resize-pane -R 5

        # Splits
        bind v split-window -v
        bind \; split-window -h

        # Tabs (windows)
        bind c new-window
        bind 1 select-window -t 1
        bind 2 select-window -t 2
        bind 3 select-window -t 3
        bind 4 select-window -t 4
        bind 5 select-window -t 5
        bind 6 select-window -t 6
        bind 7 select-window -t 7
        bind 8 select-window -t 8

        # Copy mode
        bind [ copy-mode

        # Bind 'v' to characterwise selection
        bind -T copy-mode-vi v send -X begin-selection

        # Bind 'V' to linewise selection
        bind -T copy-mode-vi V send -X select-line

        # Send Ctrl+A
        bind C-a send-prefix
      '';
    };
  };
}
