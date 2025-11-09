{
  makeRustPlatform,
  rust-bin,
  sources,
}:
let
  rustPlatform = makeRustPlatform {
    cargo = rust-bin.selectLatestNightlyWith (toolchain: toolchain.default);
    rustc = rust-bin.selectLatestNightlyWith (toolchain: toolchain.default);
  };
in
rustPlatform.buildRustPackage {
  inherit (sources.blink-pairs) pname src version;

  cargoLock = sources.blink-pairs.cargoLock."Cargo.lock";

  # Tries to call git
  preBuild = ''
    rm build.rs
  '';

  postInstall = ''
    cp -r {lua,queries} "$out"
    mkdir -p "$out/doc"
    mkdir -p "$out/target"
    mv "$out/lib" "$out/target/release"
  '';

  doCheck = false;

  # Uses rust nightly
  env.RUSTC_BOOTSTRAP = true;
  # Don't move /doc to $out/share
  forceShare = [ ];
}
