final: prev: {
  google-sans = final.callPackage ./google-sans.nix {};
  multicolor-sddm-theme = final.callPackage ./multicolor-sddm-theme.nix {};
  spotify = final.callPackage ./spotify.nix {};
  TLauncher = final.callPackage ./TLauncher {};
}
