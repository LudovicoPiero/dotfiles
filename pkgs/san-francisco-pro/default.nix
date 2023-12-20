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
  meta = with lib; {
    description = "San Francisco Pro Fonts";
    homepage = "https://github.com/sahibjotsaggu/San-Francisco-Pro-Fonts";
    license = licenses.unfree;
    maintainers = with maintainers; [ludovicopiero];
    platforms = platforms.all;
  };
}
