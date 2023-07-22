{
  lib,
  fetchFromGitHub,
  ...
}:
fetchFromGitHub {
  pname = "San-Francisco-Pro-Fonts";
  owner = "sahibjotsaggu";
  repo = "San-Francisco-Pro-Fonts";
  rev = "8bfea09aa6f1139479f80358b2e1e5c6dc991a58";
  fetchSubmodules = false;
  sha256 = "sha256-8XVzzBDKnezRElyCwDQJ5VZP7ARuDxyi0Z8TFNGz2p0";

  postFetch = ''
    mkdir -p $out/share/fonts/San-Francisco-Pro
    cp -r $out/*.ttf $out/share/fonts/San-Francisco-Pro
  '';

  meta = with lib; {
    description = "San Francisco Pro Fonts";
    homepage = "https://github.com/sahibjotsaggu/San-Francisco-Pro-Fonts";
    license = licenses.unfree;
    platforms = platforms.all;
  };
}
