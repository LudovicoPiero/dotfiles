# https://github.com/FedericoSchonborn/nur-packages/blob/main/packages/firefox-gnome-theme/default.nix
{
  lib,
  stdenvNoCC,
  sources,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  inherit (sources.firefox-gnome-theme) pname version src;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/
    cp -r $src/* $out/

    runHook postInstall
  '';

  meta = {
    description = "A GNOME theme for Firefox";
    homepage = "https://github.com/rafaelmardojai/firefox-gnome-theme";
    license = lib.licenses.unlicense;
    maintainers = with lib.maintainers; [ ludovicopiero ];
  };
})
