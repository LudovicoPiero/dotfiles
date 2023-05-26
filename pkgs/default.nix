{pkgs ? (import ../nixpkgs.nix) {}}: {
  multicolor-sddm-theme = pkgs.callPackage ./multicolor-sddm-theme.nix {};
  google-sans = pkgs.callPackage ./google-sans.nix {};
  san-francisco-pro = pkgs.callPackage ./san-francisco-pro.nix {};
  material-symbols = pkgs.callPackage ./material-symbols.nix {};
}
