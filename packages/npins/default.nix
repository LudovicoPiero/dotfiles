{
  lib,
  pkgs,
  rustPlatform,
  makeWrapper,
  stdenv,
  darwin,
  # runtime dependencies
  nix-prefetch-git,
  nix-prefetch-docker,
  git, # for git ls-remote

  makeRustPlatform,
  rust-bin,
  sources,
}:
let
  rustPlatform = makeRustPlatform {
    cargo = rust-bin.selectLatestNightlyWith (toolchain: toolchain.default);
    rustc = rust-bin.selectLatestNightlyWith (toolchain: toolchain.default);
  };

  runtimePath = lib.makeBinPath [
    nix-prefetch-git
    nix-prefetch-docker
    git
  ];
in
rustPlatform.buildRustPackage {
  inherit (sources.npins) pname src version;

  cargoLock = sources.npins.cargoLock."Cargo.lock";

  buildInputs = lib.optional stdenv.isDarwin (
    with darwin.apple_sdk.frameworks; [ Security ]
  );
  nativeBuildInputs = [ makeWrapper ];

  cargoBuildFlags = [
    "--bin"
    "npins"
    "--features"
    "clap,crossterm,env_logger"
  ];

  # (Almost) all tests require internet
  doCheck = false;

  postFixup = ''
    wrapProgram $out/bin/npins --prefix PATH : "${runtimePath}"
  '';

  meta.mainProgram = "npins";
}
