{
  pkgs,
  extraModulesPath,
  lib,
  ...
}: let
  inherit
    (pkgs)
    alejandra
    cachix
    editorconfig-checker
    nixUnstable
    nodePackages
    shfmt
    treefmt
    nixos-generators
    ;

  pkgWithCategory = category: package: {inherit package category;};
  devos = pkgWithCategory "devos";
  formatter = pkgWithCategory "linter";
in {
  imports = ["${extraModulesPath}/git/hooks.nix" ./hooks];

  packages = [
    alejandra
    nodePackages.prettier
    shfmt
    editorconfig-checker
  ];

  commands =
    [
      (devos nixUnstable)
      (formatter treefmt)
    ]
    ++ lib.optionals (!pkgs.stdenv.buildPlatform.isi686) [
      (devos cachix)
    ]
    ++ lib.optionals pkgs.stdenv.hostPlatform.isLinux [
      (devos nixos-generators)
    ];
}
