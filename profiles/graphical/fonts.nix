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
      iosevka-comfy.comfy
      sarasa-gothic
      emacs-all-the-icons-fonts

      noto-fonts-cjk
      noto-fonts-cjk-sans
      noto-fonts-emoji
      twemoji-color-font

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
    fontconfig = {
      enable = true;
      defaultFonts = {
        serif = [
          "Sarasa Gothic C"
          "Sarasa Gothic J"
          "Sarasa Gothic K"
        ];

        sansSerif = [
          "Sarasa Gothic C"
          "Sarasa Gothic J"
          "Sarasa Gothic K"
        ];

        monospace = [
          "Iosevka Nerd Font"
          "Sarasa Mono C"
          "Sarasa Mono J"
          "Sarasa Mono K"
        ];

        emoji = ["Twitter Color Emoji"];
      };
    };
  };
}
