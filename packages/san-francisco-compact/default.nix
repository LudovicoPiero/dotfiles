{
  lib,
  stdenvNoCC,
  sources,
}:
stdenvNoCC.mkDerivation {
  inherit (sources.san-francisco-fonts) version src;
  pname = "san-francisco-compact";

  buildPhase = ''
    runHook preBuild

    # Create the destination directory
    mkdir -p $out/share/fonts/SF-Compact

    # Copy the .ttf & .otf files to the destination directory
    cp -r "$src/SF Compact/"*.ttf "$src/SF Pro/"*.otf $out/share/fonts/SF-Compact

    runHook postBuild
  '';

  meta = {
    description = "San Francisco Compact Fonts";
    homepage = "https://github.com/oyezcubed/Apple-Fonts-San-Francisco-New-York";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ ludovicopiero ];
    platforms = lib.platforms.all;
  };
}
