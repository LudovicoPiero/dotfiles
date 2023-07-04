{
  pkgs,
  stdenv,
  ...
}:
with pkgs;
  stdenv.mkDerivation {
    name = "gbar";
    src = fetchFromGitHub {
      owner = "scorpion-26";
      repo = "gBar";
      rev = "75674654544ee7f71f8504321bd0733da6550b97";
      sha256 = "sha256-06Rz8DjgVDG7Srj/rPCSEOKhpPRkudimimoExMaYufA=";
    };

    nativeBuildInputs = [
      pkg-config
      meson
      cmake
      ninja
    ];
    buildInputs = [
      wayland
      wayland-protocols
      wayland-scanner
      bluez
      gtk3
      gtk-layer-shell
      libpulseaudio
      stb
      libdbusmenu-gtk3
    ];
  }
