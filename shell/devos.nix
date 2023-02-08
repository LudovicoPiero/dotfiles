{
  pkgs,
  extraModulesPath,
  inputs,
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
    nvfetcher-bin
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
      {
        category = "devos";
        name = nvfetcher-bin.pname;
        help = nvfetcher-bin.meta.description;
        command = "cd $PRJ_ROOT/pkgs; ${nvfetcher-bin}/bin/nvfetcher -c ./sources.toml $@";
      }

      (formatter treefmt)
    ]
    ++ lib.optionals (!pkgs.stdenv.buildPlatform.isi686) [
      (devos cachix)
    ]
    ++ lib.optionals pkgs.stdenv.hostPlatform.isLinux [
      (devos nixos-generators)
      (devos inputs.deploy.packages.${pkgs.system}.deploy-rs)
    ];
}
