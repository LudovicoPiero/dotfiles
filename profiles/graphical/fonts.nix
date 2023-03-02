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
      twemoji-color-font

      jetbrains-mono
      iosevka
      ubuntu_font_family
    ];

    # use fonts specified by user rather than default ones
    enableDefaultFonts = false;
    fontconfig = {
      enable = true;
      defaultFonts = {
        serif = [
          "Google Sans"
          "Sarasa Gothic C"
          "Sarasa Gothic J"
          "Sarasa Gothic K"
        ];

        sansSerif = [
          "Google Sans"
          "Sarasa Gothic C"
          "Sarasa Gothic J"
          "Sarasa Gothic K"
        ];

        monospace = [
          "Iosevka"
          "Sarasa Mono C"
          "Sarasa Mono J"
          "Sarasa Mono K"
        ];

        emoji = ["Twitter Color Emoji"];
      };
    };
  };
}
