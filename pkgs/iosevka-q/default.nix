{
  stdenv,
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  darwin,
  remarshal,
  ttfautohint-nox,
  privateBuildPlan ? ''
    [buildPlans.iosevka-q]
    family = "Iosevka q"
    spacing = "term"
    serifs = "sans"
    noCvSs = true
    exportGlyphNames = true

      [buildPlans.iosevka-q.variants]
      inherits = "ss14"

        [buildPlans.iosevka-q.variants.design]
        underscore = "low"
        brace = "curly-flat-boundary"
        dollar = "open"

      [buildPlans.iosevka-q.ligations]
      inherits = "dlig"
  '',
  extraParameters ? null,
  set ? "q",
}:
assert (privateBuildPlan != null) -> set != null;
assert (extraParameters != null) -> set != null;
  buildNpmPackage rec {
    pname =
      if set != null
      then "iosevka-${set}"
      else "iosevka";
    version = "28.0.0";

    src = fetchFromGitHub {
      owner = "be5invis";
      repo = "iosevka";
      rev = "v${version}";
      hash = "sha256-xicXPIIsaYouYc6yzaH36R5d6+73wkSCpJzSXV6ekHI=";
    };

    npmDepsHash = "sha256-9FSG8pnEVb5K4wR0Xsr9Cq+dnorP8rxPwraKWBBDlCA=";

    nativeBuildInputs =
      [
        remarshal
        ttfautohint-nox
      ]
      ++ lib.optionals stdenv.isDarwin
      [
        # libtool
        darwin.cctools
      ];

    buildPlan =
      if builtins.isAttrs privateBuildPlan
      then builtins.toJSON {buildPlans.${pname} = privateBuildPlan;}
      else privateBuildPlan;

    inherit extraParameters;
    passAsFile =
      ["extraParameters"]
      ++ lib.optionals
      (!(builtins.isString privateBuildPlan && lib.hasPrefix builtins.storeDir privateBuildPlan))
      ["buildPlan"];

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
      maintainers = with maintainers; [ludovicopiero];
    };
  }
