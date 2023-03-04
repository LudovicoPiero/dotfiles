final: prev: {
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
          asterisk = "penta-low"
          caret = "medium"
          brace = "curly-flat-boundary"
          number-sign = "upright"
          ampersand = "closed"
          at = "threefold"
          dollar = "open"
          percent = "dots"
          bar = "force-upright"
          question = "smooth"
          punctuation-dot = "square"

        [buildPlans.iosevka-q.ligations]
        inherits = "clike"
    '';

    set = "q";
  };
}
