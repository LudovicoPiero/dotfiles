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
  sha256 = "1mgrg676lp944cmz1sgspxm2qni8y53lhai1zz18k1svjbhi5lsr";

  postFetch = ''
    mkdir -p $out/share/fonts/San-Francisco-Pro
    cp -r $out/*.ttf $out/share/fonts/San-Francisco-Pro
  '';

  meta = with lib; {
    description = "San Francisco Pro Fonts";
    homepage = "https://github.com/sahibjotsaggu/San-Francisco-Pro-Fonts";
    platforms = platforms.all;
  };
}
