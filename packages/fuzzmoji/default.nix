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

  buildInputs = [
    fuzzel
    wl-clipboard
    libnotify
  ];

  installPhase = ''
    mkdir -p $out/{bin,fuzzmoji}

    cp fuzzmoji $out/bin
    cp emoji-list $out/fuzzmoji

    chmod +x $out/bin/fuzzmoji

    substituteInPlace $out/bin/fuzzmoji \
      --replace-fail 'SEARCH_DIRS="''${XDG_DATA_DIRS:-/usr/local/share/:/usr/share/}:''${XDG_DATA_HOME:-''$HOME/.local/share}"' \
                     'SEARCH_DIRS="'$out'"'
  '';

  meta = {
    description = "Quickly find Emoji with Fuzzel";
    homepage = "https://codeberg.org/codingotaku/fuzzmoji";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ ludovicopiero ];
    mainProgram = "fuzzmoji";
  };
}
