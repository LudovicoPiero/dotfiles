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
          format-all
          command-log-mode
          company
          projectile
          counsel-projectile
          nix-mode
          lsp-mode
          lsp-ui
          flycheck
          rustic

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

    # services.emacs.enable = true;
  };
  fonts.fonts = with pkgs; [emacs-all-the-icons-fonts];
}
