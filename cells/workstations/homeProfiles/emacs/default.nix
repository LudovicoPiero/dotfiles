{pkgs, ...}: {
  programs.emacs = {
    enable = true;
    package = pkgs.emacs-pgtk.override {
      withTreeSitter = true;
    };
    extraPackages = epkgs: [epkgs.vterm epkgs.magit];
  };
}
