{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  cfg = config.mine.fonts;
  inherit (lib) mkIf mkOption types;
in
{
  options.mine.fonts = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Enable custom fonts setting.
      '';
    };
  };

  config = mkIf cfg.enable {
    fonts = {
      fontDir.enable = true;
      packages = lib.attrValues {
        inherit (inputs.self.packages.${pkgs.system}) san-francisco-pro sarasa-gothic iosevka-q;

        inherit (pkgs) material-design-icons noto-fonts-emoji symbola;

        nerdfonts = pkgs.nerdfonts.override { fonts = [ "NerdFontsSymbolsOnly" ]; };
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
