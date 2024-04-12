{ pkgs, ... }:
{
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
    '';

    plugins = with pkgs.tmuxPlugins; [
      {
        plugin = mkTmuxPlugin {
          pluginName = "sensible";
          version = "unstable-2022-08-15";
          src = pkgs.fetchFromGitHub {
            owner = "tmux-plugins";
            repo = "tmux-sensible";
            rev = "25cb91f42d020f675bb0a2ce3fbd3a5d96119efa";
            hash = "sha256-sw9g1Yzmv2fdZFLJSGhx1tatQ+TtjDYNZI5uny0+5Hg=";
          };
        };
      }
      {
        plugin = mkTmuxPlugin {
          pluginName = "vim-tmux-navigator";
          rtpFilePath = "vim-tmux-navigator.tmux";
          version = "unstable-2023-12-24";
          src = pkgs.fetchFromGitHub {
            owner = "christoomey";
            repo = "vim-tmux-navigator";
            rev = "38b1d0402c4600543281dc85b3f51884205674b6";
            hash = "sha256-4WpY+t4g9mmUrRQgTmUnzpjU8WxtrJOWz
IL/vY4wR3I=";
          };
        };
      }
      {
        plugin = mkTmuxPlugin {
          pluginName = dracula;
          rtpFilePath = "dracula.tmux";
          version = "unstable-2024-04-10";
          src = pkgs.fetchFromGitHub {
            owner = "dracula";
            repo = "tmux";
            rev = "c2b1d67cbda5c44ea8ee25d2ab307063e6959d0f";
            hash = "sha256-rP4kiSSz/JN47ogC5S+2h5ACS0tgjvRxCclBc5WQZGk";
          };
          extraConfig = ''
            set -g status-position top
            set -g @dracula-show-powerline true
            set -g @dracula-fixed-location "Kameoka"
            set -g @dracula-show-fahrenheit false
            set -g @dracula-plugins "cpu-usage ram-usage"
            set -g @dracula-refresh-rate 10
          '';
        };
      }
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
