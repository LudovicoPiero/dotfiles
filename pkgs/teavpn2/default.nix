{
  stdenv,
  fetchFromGitHub,
  gnumake,
  lib,
  ...
}:
stdenv.mkDerivation rec {
  name = "teavpn2-${version}";
  version = "unstable-07-25-2023";

  src = fetchFromGitHub {
    owner = "TeaInside";
    repo = "teavpn2";
    rev = "b21898d001a2e7b821e045162dd18f13561cb04b";
    hash = "sha256-0/eHK2/+pn6NfawL1xLJv4jDBFvLwELSXNWLUvff1gs=";
  };

  nativeBuildInputs = [gnumake];

  patches = [./nix.patch];

  buildPhase = ''
    make -j$(nproc);
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp teavpn2 $out/bin
  '';

  meta = with lib; {
    description = "An open source VPN Software";
    homepage = "https://github.com/TeaInside/teavpn2";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ludovicopiero];
    platforms = platforms.linux;
  };
}
