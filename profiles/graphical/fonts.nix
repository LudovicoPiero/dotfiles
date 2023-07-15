{
  inputs,
  pkgs,
  ...
}: {
  fonts = {
    fontDir.enable = true;
    fonts = with pkgs; [
      # Icons
      inputs.self.packages.${pkgs.system}.san-francisco-pro
      inputs.self.packages.${pkgs.system}.iosevka-q
      emacs-all-the-icons-fonts
      font-awesome
      sarasa-gothic
      noto-fonts-emoji
      (nerdfonts.override {fonts = ["NerdFontsSymbolsOnly"];})
    ];

    # use fonts specified by user rather than default ones
    enableDefaultFonts = false;
    fontconfig = {
      enable = true;
      defaultFonts = {
        serif = [
          "SF Pro"
          "Sarasa Gothic C"
          "Sarasa Gothic J"
          "Sarasa Gothic K"
        ];

        sansSerif = [
          "SF Pro"
          "Sarasa Gothic C"
          "Sarasa Gothic J"
          "Sarasa Gothic K"
        ];

        monospace = [
          "SF Pro Rounded"
          "Sarasa Mono C"
          "Sarasa Mono J"
          "Sarasa Mono K"
        ];

        emoji = ["Noto Color Emoji"];
      };
    };
  };
}
