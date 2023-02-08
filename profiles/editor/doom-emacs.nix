{
  config,
  pkgs,
  inputs,
  location,
  ...
}: {
  services.emacs.enable = true;

  system.userActivationScripts = {
    # Installation script every time nixos-rebuild is run. So not during initial install.
    doomEmacs = {
      text = ''
        source ${config.system.build.setEnvironment}
        EMACS="$HOME/.emacs.d"

        if [ ! -d "$EMACS" ]; then
          ${pkgs.git}/bin/git clone --depth=1 --single-branch https://github.com/hlissner/doom-emacs.git $EMACS
          yes | $EMACS/bin/doom install
          rm -r $HOME/.doom.d
          ${pkgs.git}/bin/git clone -b doom.d --single-branch https://github.com/lewdovico/dotfiles.git $HOME/.doom.d
          $EMACS/bin/doom sync
        else
          $EMACS/bin/doom sync
        fi
      ''; # It will always sync when rebuild is done. So changes will always be applied.
    };
  };

  fonts.fonts = with pkgs; [emacs-all-the-icons-fonts];

  environment.systemPackages = with pkgs; [
    inputs.nil.packages.${pkgs.system}.default
    nodejs-16_x # for copilot
    sumneko-lua-language-server
    stylua # Lua
    rust-analyzer
    ripgrep
    alejandra
    ripgrep
    coreutils
    fd
    #git
  ]; # Dependencies
}
