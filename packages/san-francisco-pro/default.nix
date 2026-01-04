{
  lib,
  stdenvNoCC,
  sources,
}:
stdenvNoCC.mkDerivation {
  inherit (sources.san-francisco-fonts) version src;
  pname = "san-francisco-pro";

  buildPhase = ''
    runHook preBuild

    # Create the destination directory
    mkdir -p $out/share/fonts/SF-Pro

    # Copy the .ttf & .otf files to the destination directory
    cp -r "$src/SF Pro/"*.ttf "$src/SF Pro/"*.otf $out/share/fonts/SF-Pro

    runHook postBuild
  '';

  meta = {
    description = "San Francisco Pro Fonts";
    homepage = "https://github.com/oyezcubed/Apple-Fonts-San-Francisco-New-York";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ ludovicopiero ];
    platforms = lib.platforms.all;
  };
}
