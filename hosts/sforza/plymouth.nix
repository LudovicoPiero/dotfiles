{pkgs, ...}: {
  boot.plymouth = let
    theme = "pixels";
  in {
    enable = true;
    themePackages = [
      (pkgs.adi1090x-plymouth-themes.override {
        selected_themes = [theme];
      })
    ];
    inherit theme;
  };
}
