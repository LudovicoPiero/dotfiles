{
  stdenvNoCC,
  fetchzip,
  lib,
  sources,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  inherit (sources.macos-hyprcursors) pname version;
  src = fetchzip {
    name = "macOS-hyprcursor";
    url = "https://github.com/driedpampas/macOS-hyprcursor/releases/download/${sources.macos-hyprcursors.version}/macOS.Hyprcursor.SVG.White.tar.gz";
    hash = "sha256-c3sYpdFZgN6vxG+Pfj6D69QQvuyGp673TI9JsaUsLFc=";
  };

  dontBuild = true;
  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp -r hyprcursors/ manifest.hl $out

    runHook postInstall
  '';

  meta = {
    description = "macOS cursors - hypr edition";
    homepage = "https://github.com/driedpampas/macOS-hyprcursor";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ ludovicopiero ];
  };
})
