{
  lib,
  gcc13Stdenv,
  sources,

  xdg-terminal-exec,
  scdoc,
}:
let
  stdenv = gcc13Stdenv;
in
stdenv.mkDerivation (finalAttrs: {
  inherit (sources.app2unit) pname version src;

  patchPhase = ''
    substituteInPlace app2unit \
      --replace-quiet "xdg-terminal-exec" "${xdg-terminal-exec}/bin/xdg-terminal-exec"

  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp app2unit $out/bin

    runHook postInstall
  '';

  nativeBuildInputs = [ scdoc ];

  meta = {
    description = "Launches Desktop Entries as Systemd user units";
    homepage = "https://github.com/Vladimir-csp/app2unit";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ ludovicopiero ];
    mainProgram = "app2unit";
  };
})
