final: prev: {
  iosevka-ft = prev.iosevka.override {
    privateBuildPlan = ''
      [buildPlans.iosevka-ft]
      family = "Iosevka FT"
      spacing = "term"
      serifs = "sans"
      no-cv-ss = true
      export-glyph-names = false

        [buildPlans.iosevka-ft.variants]
        inherits = "ss14"

          [buildPlans.iosevka-ft.variants.design]
          capital-j = "serifless"
          j = "serifless"
          l = "serifed-flat-tailed"
          tilde = "low"
          caret = "medium"
          paren = "flat-arc"
          brace = "curly-flat-boundary"
          ampersand = "closed"
          at = "threefold"
          dollar = "open"
          lig-ltgteq = "slanted"
          lig-neq = "more-slanted"
          lig-equal-chain = "without-notch"
          lig-hyphen-chain = "without-notch"

        [buildPlans.iosevka-ft.ligations]
        inherits = "clike"
    '';
    set = "ft";
  };
}
