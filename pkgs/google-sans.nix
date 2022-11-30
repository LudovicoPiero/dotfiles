{
  pkgs,
  lib,
  fetchFromGitHub,
  ...
}:
fetchFromGitHub {
  pname = "Google-Sans-Fonts";
  owner = "sahibjotsaggu";
  repo = "Google-Sans-Fonts";
  rev = "b1826355d8212378e5fd6094bbe504268fa6f85d";
  fetchSubmodules = false;
  sha256 = "KJsLM0NkhxGtJ2GGTzIUjh3lWIdQFZQoD5c3AG2ApTg=";

  postFetch = ''
    install -Dm644 $src/GoogleSans-*.ttf -t $out/share/fonts/ttf
    echo "Installing fonts to $out/share/fonts/ttf"
  '';

  meta = with lib; {
    description = "Google Sans Fonts";
    homepage = "https://github.com/sahibjotsaggu/Google-Sans-Fonts";
    platforms = platforms.all;
  };
}
