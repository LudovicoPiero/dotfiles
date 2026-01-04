{
  lib,
  stdenvNoCC,
  sources,
}:
stdenvNoCC.mkDerivation {
  inherit (sources.san-francisco-fonts) version src;
  pname = "new-york-font";

  buildPhase = ''
    runHook preBuild

    # Create the destination directory
    mkdir -p $out/share/fonts/New-York-Font

    # Copy the .ttf & .otf files to the destination directory
    cp -r "$src/New York Font/"*.ttf "$src/New York Font/"*.otf $out/share/fonts/New-York-Font

    runHook postBuild
  '';

  meta = {
    description = "New York Font";
    homepage = "https://github.com/oyezcubed/Apple-Fonts-San-Francisco-New-York";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ ludovicopiero ];
    platforms = lib.platforms.all;
  };
}
