{
  inputs,
  pkgs,
  ...
}: {
  fonts = {
    fontconfig.enable = true;
    fontDir.enable = true;
    fonts = with pkgs; [
      # Icons
      #inputs.self.packages.${pkgs.system}.material-symbols
      #inputs.self.packages.${pkgs.system}.google-sans

      powerline-fonts
      dejavu_fonts

      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      noto-fonts-cjk-sans
      liberation_ttf

      (nerdfonts.override {
        fonts = [
          "Iosevka"
          "UbuntuMono"
          "JetBrainsMono"
        ];
      })
    ];

    # use fonts specified by user rather than default ones
    enableDefaultFonts = false;

    # user defined fonts
    # the reason there's Noto Color Emoji everywhere is to override DejaVu's
    # B&W emojis that would sometimes show instead of some Color emojis
    fontconfig.defaultFonts = {
      serif = ["DejaVu Sans" "Noto Color Emoji"];
      sansSerif = ["DejaVu Sans" "Noto Color Emoji"];
      monospace = ["DejaVu Sans Mono for Powerline" "Noto Color Emoji"];
      emoji = ["Noto Color Emoji"];
    };
  };
}
