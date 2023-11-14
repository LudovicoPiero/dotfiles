{
  stdenvNoCC,
  fetchFromGitHub,
  lib,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "wavefox";
  version = "1.6.119";

  src = fetchFromGitHub {
    owner = "QNetITQ";
    repo = "WaveFox";
    rev = "v${finalAttrs.version}";
    hash = "sha256-mDwZSoBXnxWz7HMRxPzF+daLz7TJYaLxez3RbfYV/+M=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/
    cp -r $src/* $out/

    runHook postInstall
  '';

  meta = {
    description = "Firefox CSS Theme/Style for manual customization";
    homepage = "https://github.com/QNetITQ/WaveFox";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ludovicopiero];
  };
})
