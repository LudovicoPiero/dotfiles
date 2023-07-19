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
    nodePackages
    stylua
    shfmt
    treefmt
    nixos-generators
    ;

  inherit (inputs.ragenix.packages.x86_64-linux) ragenix;
  inherit (inputs.nix-super.packages.x86_64-linux) nix;

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
      (devos nix)
      (formatter treefmt)
      (secrets ragenix)
    ]
    ++ lib.optionals (!pkgs.stdenv.buildPlatform.isi686) [
      (devos cachix)
    ]
    ++ lib.optionals pkgs.stdenv.hostPlatform.isLinux [
      (devos nixos-generators)
    ];
}
