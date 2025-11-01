{
  lib,
  gcc13Stdenv,
  sources,

  systemdMinimal,
  pkg-config,
}:
let
  stdenv = gcc13Stdenv;
in
stdenv.mkDerivation {
  inherit (sources.runapp) pname version src;

  hardeningDisable = [ "fortify" ];

  postPatch = ''
    substituteInPlace Makefile \
      --replace "install_runner := sudo" "install_runner :=" \
      --replace "-march=native" ""
  '';

  makeFlags = [ "PREFIX=$(out)" ];

  buildPhase = ''
    make release
  '';

  installPhase = ''
    mkdir -p $out/bin
    install -Dm755 build_release/runapp $out/bin/runapp
  '';

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    systemdMinimal # libsystemd
  ];

  meta = {
    description = "Application runner for Linux desktop environments that integrate with systemd";
    homepage = "https://github.com/c4rlo/runapp";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ludovicopiero ];
    mainProgram = "runapp";
  };
}
