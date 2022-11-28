{pkgs, ...}: let
  inherit (pkgs.tmuxPlugins) mkTmuxPlugin;
  inherit (pkgs) fetchFromGitHub;
in {
  programs.tmux = {
    enable = true;
    clock24 = true;
    shell = "${pkgs.fish}/bin/fish";
    prefix = "C-a";
    plugins = [
      {
        plugin = mkTmuxPlugin {
          pluginName = "catppuccin";
          version = "d9e5c6d";
          src = fetchFromGitHub {
            owner = "catppuccin";
            repo = "tmux";
            rev = "d9e5c6d1e3b2c6f6f344f7663691c4c8e7ebeb4c";
            sha256 = "sha256-k0nYjGjiTS0TOnYXoZg7w9UksBMLT+Bq/fJI3f9qqBg=";
          };
        };
        extraConfig = "set -g @catppuccin_flavour 'mocha'";
      }
    ];
    escapeTime = 0;
    extraConfig = ''
      # split panes using - and |
      bind | split-window -h
      bind - split-window -v
      unbind '"'
      unbind %
      # switch panes using Alt + hjkl
      bind -n M-h select-pane -L
      bind -n M-j select-pane -D
      bind -n M-k select-pane -U
      bind -n M-l select-pane -R
      # enable mouse control
      set -g mouse on
      # enable true color support
      set -g default-terminal 'screen-256color'
      set -ga terminal-overrides ',*256col*:Tc'
      # disable esc key timeout
      set -s escape-time 0
    '';
  };
}
