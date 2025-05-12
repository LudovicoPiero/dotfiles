{
  lib,
  stdenvNoCC,
  sources,
  fuzzel,
  wl-clipboard,
  libnotify,
}:

stdenvNoCC.mkDerivation {
  inherit (sources.fuzzmoji) pname version src;

  nativeBuildInputs = [
    fuzzel
    wl-clipboard
    libnotify
  ];

  installPhase = ''
    mkdir -p $out/bin
    cp fuzzmoji emoji-list $out/bin
    chmod +x $out/bin/fuzzmoji

    substituteInPlace $out/bin/fuzzmoji \
      --replace-fail /usr/share/fuzzmoji/emoji-list $out/bin/emoji-list
  '';

  meta = {
    description = "Quickly find Emoji with Fuzzel";
    homepage = "https://codeberg.org/codingotaku/fuzzmoji";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ ludovicopiero ];
    mainProgram = "fuzzmoji";
  };
}
