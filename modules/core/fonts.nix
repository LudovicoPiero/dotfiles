{
  pkgs,
  inputs,
  ...
}: {
  fonts = {
    fontDir.enable = true;
    packages = with pkgs; [
      inputs.self.packages.${pkgs.system}.san-francisco-pro
      jetbrains-mono
      sarasa-gothic

      # Icons
      material-design-icons
      noto-fonts-emoji
    ];

    # use fonts specified by user rather than default ones
    enableDefaultPackages = false;
    fontconfig = {
      enable = true;
      defaultFonts = {
        serif = [
          "SF Pro"
          "Sarasa Gothic SC"
        ];

        sansSerif = [
          "SF Pro"
          "Sarasa Gothic SC"
        ];

        monospace = [
          "SF Pro Rounded"
          "Sarasa Mono SC"
        ];

        emoji = ["Noto Color Emoji"];
      };
    };
  };
}
