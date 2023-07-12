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
      powerline-fonts
      material-symbols
      iosevka-comfy.comfy
      emacs-all-the-icons-fonts
      font-awesome
      sarasa-gothic
      noto-fonts-emoji
      (nerdfonts.override {fonts = ["Iosevka"];})
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

        emoji = ["noto-fonts-emoji"];
      };
    };
  };
}
