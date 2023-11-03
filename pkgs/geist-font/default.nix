{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:
stdenvNoCC.mkDerivation rec {
  pname = "geist-font";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "vercel";
    repo = "geist-font";
    rev = version;
    hash = "sha256-WAzNsA80qhBvhutYoHTbp7QbcScNfGWBKIvOA3/ERlc=";
  };

  postInstall = ''
    install -Dm444 packages/next/dist/fonts/geist-{mono,sans}/*.woff2 -t $out/share/fonts/woff2
  '';

  meta = {
    description = "Font family created by Vercel in collaboration with Basement Studio";
    homepage = "https://vercel.com/font";
    license = lib.licenses.ofl;
    maintainers = with lib.maintainers; [ludovicopiero];
    platforms = lib.platforms.all;
  };
}
