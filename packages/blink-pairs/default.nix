{
  lib,
  pkg-config,
  vimUtils,
  stdenv,
  makeRustPlatform,
  rust-bin,
  sources,
}:
let
  rustPlatform = makeRustPlatform {
    cargo = rust-bin.selectLatestNightlyWith (toolchain: toolchain.default);
    rustc = rust-bin.selectLatestNightlyWith (toolchain: toolchain.default);
  };

  blink-pairs-lib = rustPlatform.buildRustPackage {
    inherit (sources.blink-pairs-lib) version src pname;

    cargoLock = sources.blink-pairs-lib.cargoLock."Cargo.lock";

    env.RUSTC_BOOTSTRAP = 1;

    # NOTE: Disabled upstream too
    doCheck = false;

    nativeBuildInputs = [ pkg-config ];
  };
in
vimUtils.buildVimPlugin {
  inherit (sources.blink-pairs) version src pname;
  preInstall =
    let
      ext = stdenv.hostPlatform.extensions.sharedLibrary;
    in
    ''
      mkdir -p target/release
      ln -s ${blink-pairs-lib}/lib/libblink_pairs${ext} target/release/
    '';

  passthru = {
    # needed for the update script
    inherit blink-pairs-lib;
  };

  meta = {
    description = "Rainbow highlighting and intelligent auto-pairs for Neovim";
    homepage = "https://github.com/Saghen/blink.pairs";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ludovicopiero ];
  };

  nvimSkipModules = [
    # Module for reproducing issues
    "repro"
  ];
}
