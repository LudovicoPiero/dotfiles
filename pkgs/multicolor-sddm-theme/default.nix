{
  stdenv,
  lib,
  fetchFromGitLab,
  ...
}:
stdenv.mkDerivation {
  name = "multicolor-sddm-theme";
  src = fetchFromGitLab {
    owner = "dwt1";
    repo = "multicolor-sddm-theme";
    rev = "798507a2362459a6084d7c140c67c23702913c8c";
    sha256 = "sha256-K6drHG564BDz4+iYZo14Pdd2gOMp+GXmxsUEnTu8DaI=";
  };

  installPhase = ''
    mkdir -p $out/share/sddm/themes/multicolor-sddm-theme
    mv * $out/share/sddm/themes/multicolor-sddm-theme
  '';

  meta = with lib; {
    description = "DT's SDDM Theme";
    homepage = "https://gitlab.com/dwt1/multicolor-sddm-theme";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ludovicopiero];
    platforms = platforms.linux;
  };
}
