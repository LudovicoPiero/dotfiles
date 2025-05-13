# https://github.com/FedericoSchonborn/nur-packages/blob/main/packages/firefox-gnome-theme/default.nix
{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "firefox-gnome-theme";
  version = "128"; # Firefox-esr

  src = fetchFromGitHub {
    owner = "rafaelmardojai";
    repo = "firefox-gnome-theme";
    tag = "v${finalAttrs.version}";
    hash = "sha256-zB+Zd0V0ayKP/zg9n1MQ8J/Znwa49adylRftxuc694k=";
  };

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
    maintainers = with lib.maintainers; [
      ludovicopiero
    ];
  };
})
