{
  lib,
  pkgs,
  config,
  inputs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.myOptions.fonts;
in
{
  options.myOptions.fonts = {
    enable = mkEnableOption "Fonts" // {
      default = config.vars.withGui;
    };
  };

  config = mkIf cfg.enable {
    fonts = {
      fontDir.enable = true;
      packages = lib.attrValues {
        inherit (inputs.self.packages.${pkgs.stdenv.hostPlatform.system})
          san-francisco-pro
          sarasa-gothic
          iosevka-q
          ;

        inherit (pkgs)
          emacs-all-the-icons-fonts
          material-design-icons
          noto-fonts-emoji
          symbola
          wqy_zenhei # For Steam
          ;
      };

      # use fonts specified by user rather than default ones
      enableDefaultPackages = false;
      fontconfig = {
        enable = true;
        defaultFonts = {
          serif = [
            "SF Pro"
            "Sarasa Gothic J"
            "Sarasa Gothic K"
            "Sarasa Gothic SC"
            "Sarasa Gothic TC"
            "Sarasa Gothic HC"
            "Sarasa Gothic CL"
            "Symbola"
            "Material Design Icons"
          ];

          sansSerif = [
            "SF Pro"
            "Sarasa Gothic J"
            "Sarasa Gothic K"
            "Sarasa Gothic SC"
            "Sarasa Gothic TC"
            "Sarasa Gothic HC"
            "Sarasa Gothic CL"
            "Symbola"
            "Material Design Icons"
          ];

          monospace = [
            "SF Pro Rounded"
            "Sarasa Mono J"
            "Sarasa Mono K"
            "Sarasa Mono SC"
            "Sarasa Mono TC"
            "Sarasa Mono HC"
            "Sarasa Mono CL"
            "Symbola"
            "Material Design Icons"
          ];

          emoji = [
            "Noto Color Emoji"
            "Material Design Icons"
            "Symbola"
          ];
        };
      };
    };
  };
}
