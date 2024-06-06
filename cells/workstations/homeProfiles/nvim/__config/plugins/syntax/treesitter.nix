{
  programs.nixvim = {
    plugins.treesitter = {
      enable = true;
      ignoreInstall = [ ];
      ensureInstalled = "all";
      folding = false;
      indent = true;
      nixGrammars = true;
    };
  };
}
