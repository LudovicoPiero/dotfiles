_final: prev: {
  iosevka-q = prev.iosevka.override {
    privateBuildPlan = ''
      [buildPlans.iosevka-q]
      family = "Iosevka q"
      spacing = "term"
      serifs = "sans"
      no-cv-ss = true
      export-glyph-names = false

        [buildPlans.iosevka-q.variants]
        inherits = "ss14"

          [buildPlans.iosevka-q.variants.design]
          capital-e = "top-left-serifed"
          asterisk = "penta-low"
          brace = "curly-flat-boundary"
          number-sign = "slanted"
          ampersand = "closed"
          dollar = "open-cap"
          question = "smooth"

        [buildPlans.iosevka-q.ligations]
        inherits = "coq"
    '';

    set = "q";
  };
}
