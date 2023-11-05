{
  pkgs,
  inputs,
  ...
}: {
  fonts = {
    fontDir.enable = true;
    packages = with pkgs; [
      inputs.self.packages.${pkgs.system}.geist-font
      inputs.self.packages.${pkgs.system}.san-francisco-pro
      jetbrains-mono
      noto-fonts-cjk-sans

      # Icons
      material-design-icons
      noto-fonts-emoji
      symbola # for fallback font
    ];

    # use fonts specified by user rather than default ones
    enableDefaultPackages = false;
    fontconfig = {
      enable = true;
      defaultFonts = {
        serif = [
          "SF Pro"
          "Noto Sans CJK JP"
          "Noto Sans CJK KR"
          "Noto Sans CJK SC"
          "Noto Sans CJK TC"
          "Symbola"
        ];

        sansSerif = [
          "SF Pro"
          "Noto Sans CJK JP"
          "Noto Sans CJK KR"
          "Noto Sans CJK SC"
          "Noto Sans CJK TC"
          "Symbola"
        ];

        monospace = [
          "Geist SemiBold"
          "Noto Sans Mono CJK JP"
          "Noto Sans Mono CJK KR"
          "Noto Sans Mono CJK SC"
          "Noto Sans Mono CJK TC"
          "Symbola"
        ];

        emoji = [
          "Noto Color Emoji"
          "Material Design Icons"
          "Symbola"
        ];
      };
    };
  };
}
