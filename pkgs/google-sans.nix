{
  lib,
  fetchFromGitHub,
  ...
}:
fetchFromGitHub {
  pname = "Google-Sans-Fonts";
  owner = "mehant-kr";
  repo = "Google-Sans-Mono";
  rev = "2535d60dba86fb711a4a87516de136b8cae92279";
  fetchSubmodules = false;
  sha256 = "sha256-TkJJ2bq1XeXUjOi6VejTOTdNzC+PQ8fbpqU/VjNddDM=";

  postFetch = ''
    mkdir -p $out/share/fonts/Google-Sans-Mono
    cp -r $out/*.ttf $out/share/fonts/Google-Sans-Mono
  '';

  meta = with lib; {
    description = "Google Sans Mono Fonts";
    homepage = "https://github.com/mehant-kr/Google-Sans-Fonts";
    platforms = platforms.all;
  };
}
