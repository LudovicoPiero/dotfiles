{
  stdenv,
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  darwin,
  remarshal,
  ttfautohint-nox,
  privateBuildPlan ? ''
    [buildPlans.IosevkaQ]
    family = "Iosevka q"
    spacing = "term"
    serifs = "sans"
    noCvSs = true
    exportGlyphNames = false

      [buildPlans.IosevkaQ.variants]
      inherits = "ss14"

        [buildPlans.IosevkaQ.variants.design]
        capital-l = "serifless"
        capital-q = "straight"
        capital-z = "straight-serifless"
        l = "serifed-flat-tailed"
        z = "straight-serifless"
        lower-alpha = "crossing"
        zero = "tall-slashed"
        punctuation-dot = "round"
        tilde = "low"
        asterisk = "penta-low"
        underscore = "high"
        caret = "medium"
        ascii-grave = "straight"
        ascii-single-quote = "straight"
        paren = "flat-arc"
        brace = "curly-flat-boundary"
        guillemet = "straight"
        number-sign = "slanted"
        at = "fourfold"
        dollar = "through"
        cent = "through"
        percent = "rings-segmented-slash"
        bar = "natural-slope"
        question = "smooth"
        lig-ltgteq = "slanted"
        lig-neq = "slightly-slanted"
        lig-equal-chain = "without-notch"
        lig-hyphen-chain = "without-notch"
        lig-plus-chain = "without-notch"
        lig-double-arrow-bar = "without-notch"
        lig-single-arrow-bar = "without-notch"

        [buildPlans.IosevkaQ.variants.italic]
        capital-l = "serifless"
        capital-q = "straight"
        capital-z = "straight-serifless"
        l = "serifed-flat-tailed"
        z = "straight-serifless"
        lower-alpha = "crossing"
        zero = "tall-slashed"
        punctuation-dot = "round"
        tilde = "low"
        asterisk = "penta-low"
        underscore = "high"
        caret = "medium"
        ascii-grave = "straight"
        ascii-single-quote = "straight"
        paren = "flat-arc"
        brace = "curly-flat-boundary"
        guillemet = "straight"
        number-sign = "slanted"
        at = "fourfold"
        dollar = "through"
        cent = "through"
        percent = "rings-segmented-slash"
        bar = "natural-slope"
        question = "smooth"
        lig-ltgteq = "slanted"
        lig-neq = "slightly-slanted"
        lig-equal-chain = "without-notch"
        lig-hyphen-chain = "without-notch"
        lig-plus-chain = "without-notch"
        lig-double-arrow-bar = "without-notch"
        lig-single-arrow-bar = "without-notch"

        [buildPlans.IosevkaQ.variants.oblique]
        capital-l = "serifless"
        capital-q = "straight"
        capital-z = "straight-serifless"
        l = "serifed-flat-tailed"
        z = "straight-serifless"
        lower-alpha = "crossing"
        zero = "tall-slashed"
        punctuation-dot = "round"
        tilde = "low"
        asterisk = "penta-low"
        underscore = "high"
        caret = "medium"
        ascii-grave = "straight"
        ascii-single-quote = "straight"
        paren = "flat-arc"
        brace = "curly-flat-boundary"
        guillemet = "straight"
        number-sign = "slanted"
        at = "fourfold"
        dollar = "through"
        cent = "through"
        percent = "rings-segmented-slash"
        bar = "natural-slope"
        question = "smooth"
        lig-ltgteq = "slanted"
        lig-neq = "slightly-slanted"
        lig-equal-chain = "without-notch"
        lig-hyphen-chain = "without-notch"
        lig-plus-chain = "without-notch"
        lig-double-arrow-bar = "without-notch"
        lig-single-arrow-bar = "without-notch"

      [buildPlans.IosevkaQ.ligations]
      inherits = "dlig"
  '',
  extraParameters ? null,
  set ? "Q",
}:
assert (privateBuildPlan != null) -> set != null;
assert (extraParameters != null) -> set != null;
buildNpmPackage rec {
  pname = if set != null then "Iosevka${set}" else "Iosevka";
  version = "28.0.7";

  src = fetchFromGitHub {
    owner = "be5invis";
    repo = "iosevka";
    rev = "v${version}";
    hash = "sha256-kNesR+t+ybY9XFWBhXJJKxG4D32B8eCjMnCBb7OIEWs=";
  };

  npmDepsHash = "sha256-V9/83fX1hEHTQYhypru4slWMA+7h/Qq/TPhhKUNU7G8=";

  nativeBuildInputs =
    [
      remarshal
      ttfautohint-nox
    ]
    ++ lib.optionals stdenv.isDarwin [
      # libtool
      darwin.cctools
    ];

  buildPlan =
    if builtins.isAttrs privateBuildPlan then
      builtins.toJSON { buildPlans.${pname} = privateBuildPlan; }
    else
      privateBuildPlan;

  inherit extraParameters;
  passAsFile =
    [ "extraParameters" ]
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
      ''}
    ${lib.optionalString
      (builtins.isString privateBuildPlan && (lib.hasPrefix builtins.storeDir privateBuildPlan))
      ''
        cp "$buildPlan" private-build-plans.toml
      ''}
    ${lib.optionalString (extraParameters != null) ''
      echo -e "\n" >> params/parameters.toml
      cat "$extraParametersPath" >> params/parameters.toml
    ''}
    runHook postConfigure
  '';

  buildPhase = ''
    export HOME=$TMPDIR
    runHook preBuild
    npm run build --no-update-notifier -- --jCmd=$NIX_BUILD_CORES --verbose=9 ttf::$pname
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
    description = "Versatile typeface for code, from code.";
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
