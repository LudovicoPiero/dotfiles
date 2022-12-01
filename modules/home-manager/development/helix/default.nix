{
  pkgs,
  lib,
  inputs,
  ...
} @ args: {
  programs.helix = {
    enable = true;
    package = inputs.helix.packages.${pkgs.system}.default;
    languages = import ./languages.nix args;
    settings = {
      theme = "catppuccin_mocha";
      editor = {
        line-number = "relative";
        cursorline = true;
        color-modes = true;
      };
      editor.indent-guides = {render = true;};
      keys.normal = {
        space.space = "file_picker";
        space.w = ":w";
        space.q = ":q";
      };
      keys.normal.space.u = {
        f = ":format"; # format using LSP formatter
        w = ":set whitespace.render all";
        W = ":set whitespace.render none";
      };
    };
  };

  home.file.".config/helix/catppuccin_mocha.toml".source = ./catppuccin_mocha.toml;
}
