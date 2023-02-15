{
  description = "Flakes for C/C++ development";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    utils.url = "github:numtide/flake-utils";
    utils.inputs.nixpkgs.follow = "nixpkgs";
  };

  outputs = {
    self,
    nixpkgs,
    ...
  } @ inputs:
    inputs.utils.lib.eachDefaultSystem
    (system: let
      pkgs = import nixpkgs {
        inherit system;
      };

      llvm = pkgs.llvmPackages_latest;
    in {
      devShell = pkgs.mkShell.override {stdenv = pkgs.clangStdenv;} rec {
        name = "C/C++ dev shell";
        packages = with pkgs; [
          # builder
          gnumake
          cmake
          bear

          # debugger
          llvm.lldb
          gdb

          # fix headers not found
          clang-tools

          # LSP and compiler
          llvm.libstdcxxClang

          # other tools
          cppcheck
          llvm.libllvm
          valgrind

          # stdlib for cpp
          llvm.libcxx

          # libs
          glm
          SDL2
          SDL2_gfx
        ];
      };
    });
}
