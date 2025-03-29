{
  emacsWithPackagesFromUsePackage,
  emacs30-pgtk,
  fetchpatch2,
  # extra tools
  nil,
  rust-analyzer,
  zls,
  clippy,
  shellcheck,
  nixfmt-rfc-style,
  rustfmt,
  black,
  isort,
}:
emacsWithPackagesFromUsePackage {
  package = emacs30-pgtk;
  config = ./config.org;
  defaultInitFile = true;
  alwaysEnsure = true;
  alwaysTangle = true;
  extraEmacsPackages = e: [
    e.use-package
    e.treesit-grammars.with-all-grammars
    # LSPs
    nil
    rust-analyzer
    zls
    # linters
    clippy
    shellcheck
    # formatters
    nixfmt-rfc-style
    rustfmt
    black
    isort
  ];
  override = _: prev: {
    use-package = prev.emacs;
  };
}
