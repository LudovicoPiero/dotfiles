{
  config,
  pkgs,
  inputs,
  ...
}: {
  home-manager.users.${config.vars.username} = {
    programs.emacs = {
      enable = true;
      package = inputs.emacs-overlay.packages.${pkgs.system}.emacsPgtk;
      extraPackages = ep:
        with ep; [
          # init.el
          use-package
          use-package-chords

          # git
          magit

          # ide
          direnv
          command-log-mode
          company
          projectile
          counsel-projectile
          nix-mode
          lsp-mode
          lsp-ui
          flycheck

          # ui
          dracula-theme
          doom-modeline
          all-the-icons
          treemacs
          treemacs-all-the-icons
          treemacs-evil
          treemacs-projectile
          treemacs-magit
          which-key

          # evil.el
          evil
          evil-collection
          undo-fu
        ];
    };

    home.packages = with pkgs; [
      inputs.nil.packages.${pkgs.system}.default
      nodejs-16_x # for copilot
      lua-language-server
      stylua # Lua
      ripgrep
      alejandra
      coreutils
      fd
    ];

    home.file = {
      ".emacs.d" = {
        source = ./emacs.d;
        recursive = true;
      };
    };

    xresources.properties = {
      # Set some Emacs GUI properties in the .Xresources file because they are
      # expensive to set during initialization in Emacs lisp. This saves about
      # half a second on startup time. See the following link for more options:
      # https://www.gnu.org/software/emacs/manual/html_node/emacs/Fonts.html#Fonts
      "Emacs.menuBar" = false;
      "Emacs.toolBar" = false;
      "Emacs.verticalScrollBars" = false;
      "Emacs.Font" = "Iosevka Nerd Font-12";
    };

    # services.emacs.enable = true;
  };
  fonts.fonts = with pkgs; [emacs-all-the-icons-fonts];
}
