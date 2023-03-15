{
  inputs,
  pkgs,
  ...
}: {
  fonts = {
    fontDir.enable = true;
    fonts = with pkgs; [
      # Icons
      inputs.self.packages.${pkgs.system}.google-sans

      powerline-fonts
      material-symbols
      iosevka-comfy.comfy
      sarasa-gothic
      emacs-all-the-icons-fonts
      font-awesome

      noto-fonts-cjk
      noto-fonts-cjk-sans
      noto-fonts-emoji

      jetbrains-mono
      iosevka
      iosevka-q # coming from overlays
      ubuntu_font_family
    ];

    # use fonts specified by user rather than default ones
    enableDefaultFonts = false;
    fontconfig = {
      enable = true;
      defaultFonts = {
        serif = [
          "Iosevka q"
          "Sarasa Gothic C"
          "Sarasa Gothic J"
          "Sarasa Gothic K"
        ];

        sansSerif = [
          "Iosevka q"
          "Sarasa Gothic C"
          "Sarasa Gothic J"
          "Sarasa Gothic K"
        ];

        monospace = [
          "Google Sans"
          "Sarasa Mono C"
          "Sarasa Mono J"
          "Sarasa Mono K"
        ];

        emoji = ["noto-fonts-emoji"];
      };
    };
  };
}
