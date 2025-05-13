{
  lib,
  stdenvNoCC,
  sources,
}:
stdenvNoCC.mkDerivation {
  inherit (sources.san-francisco-pro) pname version src;

  buildPhase = ''
    runHook preBuild

    # Create the destination directory
    mkdir -p $out/share/fonts/San-Francisco-Pro

    # Copy the .ttf & .otf files to the destination directory
    cp -r $src/*.ttf $src/*.otf $out/share/fonts/San-Francisco-Pro

    runHook postBuild
  '';
  meta = {
    description = "San Francisco Pro Fonts";
    homepage = "https://github.com/sahibjotsaggu/San-Francisco-Pro-Fonts";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ ludovicopiero ];
    platforms = lib.platforms.all;
  };
}
