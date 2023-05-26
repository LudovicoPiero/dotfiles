{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  util-linux,
}:
stdenvNoCC.mkDerivation {
  pname = "material-symbols";
  version = "unstable-3-22-23";

  src = fetchFromGitHub {
    owner = "google";
    repo = "material-design-icons";
    rev = "3912baecc97388955ce39f5e26bfb786a70cbe48";
    sha256 = "sha256-KZ2sgFKKUAaQeOIR5WIwotFS8WTsKkfczBcFz1xzH6A=";
    sparseCheckout = ["variablefont"];
  };

  nativeBuildInputs = [util-linux];

  installPhase = ''
    runHook preInstall

    rename '[FILL,GRAD,opsz,wght]' "" variablefont/*
    install -Dm755 variablefont/*.ttf -t $out/share/fonts/TTF
    install -Dm755 variablefont/*.woff2 -t $out/share/fonts/woff2

    runHook postInstall
  '';

  meta = with lib; {
    description = "Material Symbols icons by Google";
    homepage = "https://fonts.google.com/icons";
    license = lib.licenses.asl20;
    maintainers = with maintainers; [fufexan];
    platforms = platforms.all;
  };
}
