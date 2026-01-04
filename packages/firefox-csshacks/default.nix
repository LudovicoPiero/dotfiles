{ stdenvNoCC, sources, ... }:
stdenvNoCC.mkDerivation (finalAttrs: {
  inherit (sources.firefox-csshacks) pname version src;

  installPhase = ''
    runHook preInstall

    mkdir $out
    cp -r ${finalAttrs.src}/* $out/

    runHook postInstall
  '';
})
