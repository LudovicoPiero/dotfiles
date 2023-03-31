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
      emacs-all-the-icons-fonts
      font-awesome

      noto-fonts-cjk
      noto-fonts-cjk-sans
      noto-fonts-emoji

      jetbrains-mono
      (nerdfonts.override {fonts = ["Iosevka"];})
    ];

    # use fonts specified by user rather than default ones
    enableDefaultFonts = false;
    fontconfig = {
      enable = true;
      defaultFonts = {
        serif = [
          "Google Sans"
          "Noto Sans JP"
          "Noto Sans KR"
          "Noto Sans HK"
        ];

        sansSerif = [
          "Google Sans"
          "Noto Sans JP"
          "Noto Sans KR"
          "Noto Sans HK"
        ];

        monospace = [
          "Google Sans"
          "Noto Sans JP"
          "Noto Sans KR"
          "Noto Sans HK"
        ];

        emoji = ["noto-fonts-emoji"];
      };
    };
  };
}
