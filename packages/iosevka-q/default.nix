{
  stdenv,
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  cctools,
  remarshal,
  ttfautohint-nox,
  privateBuildPlan ? ''
    [buildPlans.IosevkaQ]
    family = "Iosevka Q"
    spacing = "normal"
    serifs = "sans"
    noCvSs = true
    exportGlyphNames = true

      [buildPlans.IosevkaQ.variants]
      inherits = "ss14"

      [buildPlans.IosevkaQ.ligations]
      inherits = "clike"

    [buildPlans.IosevkaQ.widths.Condensed]
    shape = 456
    menu = 3
    css = "condensed"

    [buildPlans.IosevkaQ.widths.Normal]
    shape = 600
    menu = 5
    css = "normal"

    [buildPlans.IosevkaQ.widths.SemiCondensed]
    shape = 548
    menu = 4
    css = "semi-condensed"

    [buildPlans.IosevkaQ.widths.SemiExtended]
    shape = 658
    menu = 6
    css = "semi-expanded"

    [buildPlans.IosevkaQ.widths.Extended]
    shape = 720
    menu = 7
    css = "expanded"
  '',
  extraParameters ? null,
  set ? "Q",
}:
let
  #NOTE: Moved here because newer version of nix-update require to do this
  pname = "Iosevka${toString set}";
  version = "34.6.3";

  src = fetchFromGitHub {
    owner = "be5invis";
    repo = "iosevka";
    rev = "v${version}";
    hash = "sha256-fd1yi5tNNixedUMvoiJIpg4RF9omAJTAb2TD1B7bqV4=";
  };

  npmDepsHash = "sha256-n9fLY6z29PKn8ZJVCEXno8k+YE5X01BMesaRbsMGLcI=";
in

assert (privateBuildPlan != null) -> set != null;
assert (extraParameters != null) -> set != null;
buildNpmPackage rec {
  inherit
    pname
    version
    src
    npmDepsHash
    ;

  nativeBuildInputs = [
    remarshal
    ttfautohint-nox
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # libtool
    cctools
  ];

  buildPlan =
    if builtins.isAttrs privateBuildPlan then
      builtins.toJSON { buildPlans.${pname} = privateBuildPlan; }
    else
      privateBuildPlan;

  inherit extraParameters;
  passAsFile = [
    "extraParameters"
  ]
  ++ lib.optionals (
    !(builtins.isString privateBuildPlan && lib.hasPrefix builtins.storeDir privateBuildPlan)
  ) [ "buildPlan" ];

  configurePhase = ''
    runHook preConfigure
    ${lib.optionalString (builtins.isAttrs privateBuildPlan) ''
      remarshal -i "$buildPlanPath" -o private-build-plans.toml -if json -of toml
    ''}
    ${lib.optionalString
      (builtins.isString privateBuildPlan && (!lib.hasPrefix builtins.storeDir privateBuildPlan))
      ''
        cp "$buildPlanPath" private-build-plans.toml
      ''
    }
    ${lib.optionalString
      (builtins.isString privateBuildPlan && (lib.hasPrefix builtins.storeDir privateBuildPlan))
      ''
        cp "$buildPlan" private-build-plans.toml
      ''
    }
    ${lib.optionalString (extraParameters != null) ''
      echo -e "\n" >> params/parameters.toml
      cat "$extraParametersPath" >> params/parameters.toml
    ''}
    runHook postConfigure
  '';

  buildPhase = ''
    export HOME=$TMPDIR
    runHook preBuild

    # pipe to cat to disable progress bar
    npm run build --no-update-notifier --targets ttf::$pname -- --jCmd=$NIX_BUILD_CORES --verbosity=9 | cat

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    fontdir="$out/share/fonts/truetype"
    install -d "$fontdir"
    install "dist/$pname/TTF"/* "$fontdir"
    runHook postInstall
  '';

  enableParallelBuilding = true;

  meta = with lib; {
    homepage = "https://typeof.net/Iosevka/";
    downloadPage = "https://github.com/be5invis/Iosevka/releases";
    description = "Versatile typeface for code, from code";
    longDescription = ''
      Iosevka is an open-source, sans-serif + slab-serif, monospace +
      quasi‑proportional typeface family, designed for writing code, using in
      terminals, and preparing technical documents.
    '';
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = with maintainers; [ ludovicopiero ];
  };
}
