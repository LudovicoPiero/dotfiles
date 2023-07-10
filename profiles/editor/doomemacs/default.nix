{
  config,
  pkgs,
  inputs,
  ...
}: let
  gitUrl = "https://github.com";
  doomUrl = "${gitUrl}/doomemacs/doomemacs";
in {
  home-manager.users."${config.vars.username}" = {
    home.file.".emacs.d/snippets".source = ./snippets;
  };

  services.emacs = {
    enable = true;
  };

  system.userActivationScripts = {
    # Installation script every time nixos-rebuild is run. So not during initial install.
    doomEmacs = {
      text = ''
        source ${config.system.build.setEnvironment}
        EMACS="$HOME/.emacs.d"

        if [ ! -d "$EMACS" ]; then
          ${pkgs.git}/bin/git clone --depth 1 ${doomUrl} $EMACS
          yes | $EMACS/bin/doom install
          rm -r $HOME/.doom.d
          cp -r ${./config} $HOME/.doom.d/
          $EMACS/bin/doom sync
        else
          $EMACS/bin/doom sync
        fi
      '';
    };
  };

  fonts.fonts = with pkgs; [emacs-all-the-icons-fonts];

  environment.systemPackages = with pkgs; [
    # 28.2 + native-comp
    ((emacsPackagesFor emacsNativeComp).emacsWithPackages
      (epkgs: [epkgs.vterm]))
    inputs.nil.packages.${pkgs.system}.default
    # nodejs-16_x # for copilot
    lua-language-server
    stylua # Lua
    rust-analyzer
    alejandra
    (ripgrep.override {withPCRE2 = true;})
    coreutils
    fd
    #git
  ]; # Dependencies
}
