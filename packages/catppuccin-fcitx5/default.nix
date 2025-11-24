{
  lib,
  stdenvNoCC,
  sources,

  withRoundedCorners ? true,
}:

stdenvNoCC.mkDerivation {
  inherit (sources.catppuccin-fcitx5) pname version src;

  dontConfigure = true;
  dontBuild = true;

  # Modify files here, before installation
  postPatch = lib.optionalString withRoundedCorners ''
    # Uncomments the rounded corner settings in theme.conf
    find src -name theme.conf -exec sed -i -E 's/^# (Image=(panel|highlight).svg)/\1/' {} +
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/fcitx5/themes
    cp -r src/* $out/share/fcitx5/themes/

    runHook postInstall
  '';

  meta = {
    description = "Soothing pastel theme for Fcitx5";
    homepage = "https://github.com/catppuccin/fcitx5";
    license = lib.licenses.mit;
    maintainers = lib.maintainers.ludovicopiero;
  };
}
