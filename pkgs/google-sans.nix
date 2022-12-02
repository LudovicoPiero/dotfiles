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
    mkdir -p $out/share/fonts/Google-Sans
    cp -r $out/*.ttf $out/share/fonts/Google-Sans
  '';

  meta = with lib; {
    description = "Google Sans Fonts";
    homepage = "https://github.com/sahibjotsaggu/Google-Sans-Fonts";
    platforms = platforms.all;
  };
}
