{
  programs = {
    alejandra.enable = true;
    deadnix.enable = true;
    shellcheck.enable = true;
    stylua.enable = true;
    rustfmt.enable = true;
    shfmt.enable = true;
    prettier.enable = true;
  };

  settingsFormatter = {
    stylua.options = [
      "--indent-type"
      "spaces"
      "--indent-width"
      "2"
    ];
    prettier = {
      options = ["--write"];
      includes = [
        "*.json"
        "*.yaml"
        "*.md"
      ];
    };
    shfmt.options = [
      "-s"
      "-w"
      "-i"
      "2"
    ];
  };
}
