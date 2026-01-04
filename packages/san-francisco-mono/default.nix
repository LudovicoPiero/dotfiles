{
  lib,
  stdenvNoCC,
  sources,
}:
stdenvNoCC.mkDerivation {
  inherit (sources.san-francisco-fonts) version src;
  pname = "san-francisco-mono";

  buildPhase = ''
    runHook preBuild

    # Create the destination directory
    mkdir -p $out/share/fonts/SF-Mono

    # Copy the .ttf & .otf files to the destination directory
    cp -r "$src/SF Mono/"*.ttf "$src/SF Mono/"*.otf $out/share/fonts/SF-Mono

    runHook postBuild
  '';

  meta = {
    description = "San Francisco Mono Fonts";
    homepage = "https://github.com/oyezcubed/Apple-Fonts-San-Francisco-New-York";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ ludovicopiero ];
    platforms = lib.platforms.all;
  };
}
