final: prev: {
  # keep sources this first
  sources = prev.callPackage (import ./_sources/generated.nix) {};
  # then, call packages with `final.callPackage`

  google-sans = final.callPackage ./google-sans.nix {};
  multicolor-sddm-theme = final.callPackage ./multicolor-sddm-theme.nix {};
  spotify = final.callPackage ./spotify.nix {};
  TLauncher = final.callPackage ./TLauncher {};
  albion-online = final.callPackage ./albion-online.nix {};
}
