{
  pkgs,
  stdenv,
  lib,
  fetchFromGitHub,
  ...
}:
stdenv.mkDerivation {
  name = "ttf-google-sans";
  version = "master";

  src = fetchFromGitHub {
    owner = "sahibjotsaggu";
    repo = "Google-Sans-Fonts";
    rev = "b1826355d8212378e5fd6094bbe504268fa6f85d";
    fetchSubmodules = false;
    sha256 = "KJsLM0NkhxGtJ2GGTzIUjh3lWIdQFZQoD5c3AG2ApTg=";
  };

  phases = ["installPhase"];

  installPhase = ''
    install -Dm644 $src/GoogleSans-*.ttf -t $out/share/fonts/ttf
  '';

  meta = with lib; {
    description = "Google Sans Fonts";
    homepage = "https://github.com/sahibjotsaggu/Google-Sans-Fonts";
    platforms = platforms.all;
  };
}
