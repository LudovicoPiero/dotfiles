{
  pkgs,
  config,
  lib,
  ...
}: {
  home.activation.setup-emacs-config = lib.hm.dag.entryBefore ["writeBoundary"] ''
    CONFIG="${config.xdg.configHome}/emacs"

    if [ ! -d "$CONFIG" ]; then
      ${pkgs.git}/bin/git clone --filter=tree:0 https://github.com/ludovicopiero/.emacs.d.git $CONFIG
    fi

    chown -R ${config.home.username}:users ${config.xdg.configHome}/emacs
  '';

  services.emacs = {
    enable = true;
    package = config.programs.emacs.finalPackage;
    client.arguments = ["-c"];
  };
  programs.emacs = {
    enable = true;
    package = pkgs.emacs-git.override {
      withTreeSitter = true;
      withNativeCompilation = true;
      withPgtk = true;
    };
    extraPackages = epkgs:
      with epkgs; [
        all-the-icons
        general
        vterm
        magit
      ];
  };
}
