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
    exportGlyphNames = false

      [buildPlans.IosevkaQ.variants]
      inherits = "ss14"

        [buildPlans.IosevkaQ.variants.design]
        one = "base"
        three = "two-arcs"
        seven = "straight-serifless-crossbar"
        eight = "crossing-asymmetric"
        nine = "open-contour"
        zero = "tall-slashed"
        capital-j = "serifless"
        capital-l = "serifless"
        capital-q = "straight"
        capital-z = "straight-serifless"
        g = "double-storey-open"
        i = "serifed"
        j = "flat-hook-serifed"
        l = "serifed-flat-tailed"
        q = "earless-rounded-straight-serifless"
        r = "serifless"
        s = "serifless"
        t = "flat-hook-short-neck"
        w = "straight-flat-top-serifless"
        x = "straight-serifless"
        y = "straight-serifless"
        z = "straight-serifless"
        lower-alpha = "crossing"
        cyrl-em = "hanging-serifless"
        cyrl-capital-u = "straight-serifless"
        cyrl-u = "straight-serifless"
        punctuation-dot = "round"
        braille-dot = "round"
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
        ampersand = "closed"
        at = "fourfold"
        dollar = "through"
        cent = "through"
        percent = "rings-segmented-slash"
        bar = "natural-slope"
        question = "smooth"
        decorative-angle-brackets = "middle"
        lig-ltgteq = "slanted"
        lig-neq = "slightly-slanted"
        lig-equal-chain = "without-notch"
        lig-hyphen-chain = "without-notch"
        lig-plus-chain = "without-notch"
        lig-double-arrow-bar = "without-notch"
        lig-single-arrow-bar = "without-notch"

      [buildPlans.IosevkaQ.ligations]
      inherits = "clike"
  '',
  extraParameters ? null,
  set ? "Q",
}:
let
  #NOTE: Moved here because newer version of nix-update require to do this
  pname = "Iosevka${toString set}";
  version = "33.2.2";

  src = fetchFromGitHub {
    owner = "be5invis";
    repo = "iosevka";
    rev = "v${version}";
    hash = "sha256-dhMTcceHru/uLHRY4eWzFV+73ckCBBnDlizP3iY5w5w=";
  };

  npmDepsHash = "sha256-5DcMV9N16pyQxRaK6RCoeghZqAvM5EY1jftceT/bP+o=";
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

  nativeBuildInputs =
    [
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
