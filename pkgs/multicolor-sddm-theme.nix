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
    license = licenses.gpl3;
    maintainers = with maintainers; [ludovicosforza];
    homepage = "https://gitlab.com/dwt1/multicolor-sddm-theme";
    description = "yes";
  };
}
