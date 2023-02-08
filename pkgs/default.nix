final: prev: {
  # keep sources this first
  sources = prev.callPackage (import ./_sources/generated.nix) {};
  # then, call packages with `final.callPackage`

  google-sans = prev.callPackage ./google-sans.nix {};
  multicolor-sddm-theme = prev.callPackage ./multicolor-sddm-theme.nix {};
}
