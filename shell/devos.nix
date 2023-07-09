{
  pkgs,
  extraModulesPath,
  lib,
  inputs,
  ...
}: let
  inherit
    (pkgs)
    alejandra
    cachix
    editorconfig-checker
    nixUnstable
    nodePackages
    stylua
    shfmt
    treefmt
    nixos-generators
    ;

  inherit (inputs.agenix.packages.x86_64-linux) agenix;

  pkgWithCategory = category: package: {inherit package category;};
  devos = pkgWithCategory "devos";
  formatter = pkgWithCategory "linter";
  secrets = pkgWithCategory "secrets";
in {
  imports = ["${extraModulesPath}/git/hooks.nix" ./hooks];

  packages = [
    alejandra
    nodePackages.prettier
    shfmt
    stylua
    editorconfig-checker
  ];

  commands =
    [
      (devos nixUnstable)
      (formatter treefmt)
      (secrets agenix)
    ]
    ++ lib.optionals (!pkgs.stdenv.buildPlatform.isi686) [
      (devos cachix)
    ]
    ++ lib.optionals pkgs.stdenv.hostPlatform.isLinux [
      (devos nixos-generators)
    ];
}
