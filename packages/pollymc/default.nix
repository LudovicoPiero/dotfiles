# Credit: https://github.com/NixOS/nixpkgs/pull/325889
{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  cmark,
  darwin,
  extra-cmake-modules,
  gamemode,
  ghc_filesystem,
  jdk17,
  kdePackages,
  ninja,
  stripJavaArchivesHook,
  tomlplusplus,
  zlib,

  msaClientID ? null,
  gamemodeSupport ? stdenv.isLinux,
}:

let
  libnbtplusplus = fetchFromGitHub {
    owner = "PrismLauncher";
    repo = "libnbtplusplus";
    rev = "a5e8fd52b8bf4ab5d5bcc042b2a247867589985f";
    hash = "sha256-A5kTgICnx+Qdq3Fir/bKTfdTt/T1NQP2SC+nhN1ENug=";
  };
in

assert lib.assertMsg (
  gamemodeSupport -> stdenv.isLinux
) "gamemodeSupport is only available on Linux.";

stdenv.mkDerivation (finalAttrs: {
  pname = "pollymc-unwrapped";
  version = "8.0";

  src = fetchFromGitHub {
    owner = "fn2006";
    repo = "PollyMC";
    rev = finalAttrs.version;
    hash = "sha256-DF1lxQHetDKZEpRrRZ0HQWqqMDAGNiTZoCJUARdXFSk=";
  };

  postUnpack = ''
    rm -rf source/libraries/libnbtplusplus
    ln -s ${libnbtplusplus} source/libraries/libnbtplusplus
  '';

  nativeBuildInputs = [
    cmake
    ninja
    extra-cmake-modules
    jdk17
    stripJavaArchivesHook
  ];

  buildInputs =
    [
      cmark
      ghc_filesystem
      kdePackages.qtbase
      kdePackages.quazip
      tomlplusplus
      zlib
    ]
    ++ lib.optionals stdenv.isDarwin [ darwin.apple_sdk.frameworks.Cocoa ]
    ++ lib.optional gamemodeSupport gamemode;

  hardeningEnable = lib.optionals stdenv.isLinux [ "pie" ];

  cmakeFlags =
    [
      # downstream branding
      (lib.cmakeFeature "Launcher_BUILD_PLATFORM" "nixpkgs")
    ]
    ++ lib.optionals (msaClientID != null) [
      (lib.cmakeFeature "Launcher_MSA_CLIENT_ID" (toString msaClientID))
    ]
    ++ lib.optionals (lib.versionOlder kdePackages.qtbase.version "6") [
      (lib.cmakeFeature "Launcher_QT_VERSION_MAJOR" "5")
    ]
    ++ lib.optionals stdenv.isDarwin [
      # they wrap our binary manually
      (lib.cmakeFeature "INSTALL_BUNDLE" "nodeps")
      # disable built-in updater
      (lib.cmakeFeature "MACOSX_SPARKLE_UPDATE_FEED_URL" "''")
      (lib.cmakeFeature "CMAKE_INSTALL_PREFIX" "${placeholder "out"}/Applications/")
    ];

  dontWrapQtApps = true;

  meta = {
    description = "Free, open source launcher for Minecraft";
    longDescription = ''
      Allows you to have multiple, separate instances of Minecraft (each with
      their own mods, texture packs, saves, etc) and helps you manage them and
      their associated options with a simple interface.
    '';
    homepage = "https://github.com/fn2006/PollyMC";
    changelog = "https://github.com/fn2006/PollyMC/releases/tag/${finalAttrs.src.rev}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ ludovicopiero ];
    mainProgram = "pollymc";
    platforms = lib.platforms.unix;
  };
})
