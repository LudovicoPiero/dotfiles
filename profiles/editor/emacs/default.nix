{
  config,
  pkgs,
  inputs,
  location,
  ...
}: {
  home-manager.users.${config.vars.username} = {
    programs.emacs = {
      enable = true;
      package = inputs.emacs-overlay.packages.${pkgs.system}.emacsPgtk;
      extraConfig = import ./config.nix;
      extraPackages = ep: [
        ep.magit
        ep.catppuccin-theme
        ep.nix-mode
        ep.evil
        ep.evil-collection
        ep.undo-fu
      ];
    };

    # services.emacs.enable = true;
  };

  fonts.fonts = with pkgs; [emacs-all-the-icons-fonts];

  environment.systemPackages = with pkgs; [
    inputs.nil.packages.${pkgs.system}.default
    nodejs-16_x # for copilot
    lua-language-server
    stylua # Lua
    ripgrep
    alejandra
    coreutils
    fd
  ];
}
