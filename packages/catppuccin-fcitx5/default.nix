{
  lib,
  stdenvNoCC,
  sources,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  inherit (sources.catppuccin-fcitx5) pname version src;

  dontBuild = true;

  installPhase = ''
    mkdir -p $out/share/fcitx5/themes
    cp -r ./src/* $out/share/fcitx5/themes
  '';

  meta = {
    description = "Soothing pastel theme for Fcitx5";
    homepage = "https://github.com/catppuccin/fcitx5";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [
      ludovicopiero

    ];
  };
})
