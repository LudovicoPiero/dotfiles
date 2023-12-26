{
  lib,
  stdenvNoCC,
  fetchurl,
  p7zip,
}:
stdenvNoCC.mkDerivation rec {
  pname = "sarasa-gothic";
  version = "1.0.0";

  src = fetchurl {
    # Use the 'ttc' files here for a smaller closure size.
    # (Using 'ttf' files gives a closure size about 15x larger, as of November 2021.)
    url = "https://github.com/be5invis/Sarasa-Gothic/releases/download/v${version}/Sarasa-TTC-${version}.7z";
    hash = "sha256-Fktdf6ZGjFZX6M9WSCNTnrGLrN0o+qWINTRWh/6xRRQ=";
  };

  sourceRoot = ".";

  nativeBuildInputs = [ p7zip ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/fonts/truetype
    cp *.ttc $out/share/fonts/truetype

    runHook postInstall
  '';

  meta = {
    description = "A CJK programming font based on Iosevka and Source Han Sans";
    homepage = "https://github.com/be5invis/Sarasa-Gothic";
    license = lib.licenses.ofl;
    maintainers = with lib.maintainers; [ ludovicopiero ];
    platforms = lib.platforms.all;
  };
}
