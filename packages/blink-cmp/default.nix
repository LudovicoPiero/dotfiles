{
  lib,
  stdenv,
  vimUtils,
  gitMinimal,
  makeRustPlatform,
  rust-bin,
  sources,
}:
let
  rustPlatform = makeRustPlatform {
    cargo = rust-bin.selectLatestNightlyWith (toolchain: toolchain.default);
    rustc = rust-bin.selectLatestNightlyWith (toolchain: toolchain.default);
  };

  blink-fuzzy-lib = rustPlatform.buildRustPackage {
    inherit (sources.blink-fuzzy-lib) version src pname;

    cargoLock = sources.blink-fuzzy-lib.cargoLock."Cargo.lock";

    nativeBuildInputs = [ gitMinimal ];

    env = {
      # TODO: remove this if plugin stops using nightly rust
      RUSTC_BOOTSTRAP = true;
    };
  };
in
vimUtils.buildVimPlugin {
  inherit (sources.blink-cmp) pname version src;
  preInstall =
    let
      ext = stdenv.hostPlatform.extensions.sharedLibrary;
    in
    ''
      mkdir -p target/release
      ln -s ${blink-fuzzy-lib}/lib/libblink_cmp_fuzzy${ext} target/release/libblink_cmp_fuzzy${ext}
    '';

  passthru = {
    # needed for the update script
    inherit blink-fuzzy-lib;
  };

  meta = {
    description = "Performant, batteries-included completion plugin for Neovim";
    homepage = "https://github.com/saghen/blink.cmp";
    maintainers = with lib.maintainers; [ ludovicopiero ];
  };

  nvimSkipModules = [
    # Module for reproducing issues
    "repro"
  ];
}
