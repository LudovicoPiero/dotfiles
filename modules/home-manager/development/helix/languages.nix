{
  pkgs,
  lib,
  inputs,
  ...
}:
with pkgs; [
  {
    name = "typescript";
    auto-format = true;
    language-server = {
      command = "${nodePackages.typescript-language-server}/bin/typescript-language-server";
      args = ["--stdio"];
    };
  }
  {
    name = "cpp";
    auto-format = true;
    language-server = {
      command = "${clang-tools}/bin/clangd";
    };
  }
  {
    name = "css";
    auto-format = true;
  }
  {
    name = "go";
    auto-format = true;
    language-server = {
      command = "${gopls}/bin/gopls";
    };
  }
  {
    name = "javascript";
    auto-format = true;
    language-server = {
      command = "${nodePackages.typescript-language-server}/bin/typescript-language-server";
      args = ["--stdio"];
    };
  }
  {
    name = "nix";
    auto-format = true;
    language-server = {
      command = lib.getExe inputs.nil.packages.${pkgs.system}.default;
      config.nil.formatting.command = ["alejandra" "-q"];
    };
  }
]
