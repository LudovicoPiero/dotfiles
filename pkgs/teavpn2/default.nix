{
  stdenv,
  fetchFromGitHub,
  gnumake,
  lib,
  ...
}:
stdenv.mkDerivation rec {
  name = "teavpn2-${version}";
  version = "unstable-05-01-2023";

  src = fetchFromGitHub {
    owner = "TeaInside";
    repo = "teavpn2";
    rev = "fa4215152dd2508a47476dd41e474675594a8bd3";
    hash = "sha256-jEDiCioaWr5Lh0mR5R3rKFUo5HIU9S9FwHw5UAXBuFk=";
  };

  nativeBuildInputs = [gnumake];
  buildInputs = [];

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
