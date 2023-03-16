{
  lib,
  fetchurl,
  makeDesktopItem,
  symlinkJoin,
  writeShellScriptBin,
  jdk,
  steam-run,
  withSteamRun ? true,
  pname ? "TLauncher",
  source ? null,
} @ args: let
  version = "2.86";

  src = fetchurl rec {
    name = "TLauncher-${lib.strings.sanitizeDerivationName sha256}.jar";
    url = "https://tlaun.ch/repo/downloads/TL_mcl.jar";
    sha256 = "0a4gy5ypkj6w477b5r87jn6vacc4d7mb2ypz7234j5nsf8gwpscs";
  };

  desktopItems = makeDesktopItem {
    name = pname;
    exec = pname;
    inherit icon;
    comment = "Minecraft Launcher";
    desktopName = "TLauncher";
    categories = ["Game"];
  };

  icon = ./TLauncher.svg;

  script = writeShellScriptBin pname ''
    ${
      if withSteamRun
      then steam-run + "/bin/steam-run"
      else ""
    } ${jdk}/bin/java -jar ${args.source or src}
  '';
in
  symlinkJoin {
    name = "${pname}-${version}";
    paths = [desktopItems script];

    meta = {
      description = "Minecraft Launcher";
      homepage = "https://tlaun.ch";
      maintainers = [lib.maintainers.fufexan];
      platforms = lib.platforms.linux;
    };
  }
