# src
# https://github.com/SuperPaintman/dotfiles/blob/57484e960e4505e0f486f9134680977bb643fa2f/nixos/pkgs/games/albion-online/default.nix#L16
{
  stdenv,
  lib,
  fetchurl,
  unzip,
  runtimeShell,
  steam-run,
  imagemagick,
  makeDesktopItem,
}:
stdenv.mkDerivation rec {
  pname = "albion-online";
  version = "20220719102235";

  src = fetchurl {
    url = "https://live.albiononline.com/clients/${version}/albion-online-setup";
    sha256 = "17bskrxzk35vlxp0y0rr1nf2kan8cmfr6wvfx9izq1m0486bpscj";
  };

  dontConfigure = true;
  dontBuild = true;
  dontStrip = true;
  dontFixup = true;

  nativeBuildInputs = [unzip];

  sourceRoot = ".";
  unpackPhase = ''
    unzip $src || true
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,opt}
    cp -r data $out/opt/albion-online

    cat <<EOF > $out/bin/.Albion-Online-Launcher
    #!${runtimeShell}

    set -euo pipefail

    if [ "x\$HOME" = "x" ]; then
      exit 1
    fi

    mkdir -p "\$HOME/.local/share/Albion-Online"
    chmod 700 "\$HOME/.local/share/Albion-Online"

    mkdir -p "\$HOME/.local/share/Albion-Online/launcher"
    chmod 700 "\$HOME/.local/share/Albion-Online/launcher"

    for f in $out/opt/albion-online/launcher/*; do
      if [ "x\$(basename "\$f")" = "xAlbion-Online" ]; then
        continue
      fi

      if [ -e "\$HOME/.local/share/Albion-Online/launcher/\$(basename "\$f")" ]; then
        rm "\$HOME/.local/share/Albion-Online/launcher/\$(basename "\$f")"
      fi

      ln -s "\$f" "\$HOME/.local/share/Albion-Online/launcher/\$(basename "\$f")"
    done

    # Lancher reads the dirname of this file :(.
    if [ ! -f "\$HOME/.local/share/Albion-Online/launcher/Albion-Online" ]; then
      cp "$out/opt/albion-online/launcher/Albion-Online" "\$HOME/.local/share/Albion-Online/launcher/Albion-Online"
    fi

    for name in game_x64 staging_x64; do
      mkdir -p "\$HOME/.local/share/Albion-Online/\$name"
      chmod 700 "\$HOME/.local/share/Albion-Online/\$name"
    done

    export QT_QPA_PLATFORM_PLUGIN_PATH="\$HOME/.local/share/Albion-Online/launcher/plugins/platforms"
    export QT_PLUGIN_PATH="\$HOME/.local/share/Albion-Online/launcher/plugins/"
    export QT_QPA_PLATFORM="xcb;eglfs"
    export __GL_GlslUseCollapsedArrays=0

    "\$HOME/.local/share/Albion-Online/launcher/Albion-Online" --no-sandbox "$@"
    EOF

    chmod +x $out/bin/.Albion-Online-Launcher

    cat <<EOF > $out/bin/Albion-Online-Launcher
    #!${runtimeShell}
    export LD_LIBRARY_PATH="$out/opt/albion-online/launcher"
    ${steam-run}/bin/steam-run "$out/bin/.Albion-Online-Launcher"
    EOF

    chmod +x $out/bin/Albion-Online-Launcher

    cat <<EOF > $out/bin/Albion-Online
    #!${runtimeShell}
    export LD_LIBRARY_PATH="$out/opt/albion-online/launcher"
    ${steam-run}/bin/steam-run "\$HOME/.local/share/Albion-Online/game_x64/Albion-Online"
    EOF

    chmod +x $out/bin/Albion-Online

    runHook postInstall
  '';

  desktopItemGame = makeDesktopItem {
    name = "albion-online";
    desktopName = "Albion Online";
    exec = "@out@/bin/Albion-Online";
    icon = "AlbionOnline";
    fileValidation = false;
  };

  desktopItemLauncher = makeDesktopItem {
    name = "albion-online-launcher";
    desktopName = "Albion Online Launcher";
    exec = "@out@/bin/Albion-Online-Launcher";
    icon = "AlbionOnline";
    fileValidation = false;
  };

  postInstall = ''
    mkdir -p $out/share/{applications,pixmaps}

    for d in ${desktopItemGame} ${desktopItemLauncher}; do
      install -Dm644 -t $out/share/applications \
        $d/share/applications/*
    done

    for f in $out/share/applications/*; do
      substituteInPlace "$f" \
        --replace "@out@" "$out"
    done

    ln -s "$out/opt/albion-online/AlbionOnline.xpm" "$out/share/pixmaps/AlbionOnline.xpm"

    for size in 16 24 32 64 128; do
      mkdir -p "$out/share/icons/hicolor/''${size}x''${size}/apps"
      ${imagemagick}/bin/convert \
        -resize ''${size}x''${size} \
        "$out/opt/albion-online/AlbionOnline.xpm" \
        "$out/share/icons/hicolor/''${size}x''${size}/apps/AlbionOnline.png"
    done
  '';
}
