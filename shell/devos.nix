{
  pkgs,
  extraModulesPath,
  lib,
  ...
}: let
  inherit
    (pkgs)
    alejandra
    age
    cachix
    editorconfig-checker
    nixUnstable
    nodePackages
    sops
    stylua
    shfmt
    treefmt
    nixos-generators
    ;

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
      (secrets age)
      (secrets sops)
    ]
    ++ lib.optionals (!pkgs.stdenv.buildPlatform.isi686) [
      (devos cachix)
    ]
    ++ lib.optionals pkgs.stdenv.hostPlatform.isLinux [
      (devos nixos-generators)
    ];
}
