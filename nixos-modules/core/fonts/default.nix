{ config
, lib
, pkgs
, inputs
, ...
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
        inherit (inputs.self.packages.${pkgs.system}) san-francisco-pro iosevka-q;

        inherit (pkgs)
          noto-fonts-cjk-sans
          material-design-icons
          noto-fonts-emoji
          symbola;

        nerdfonts = pkgs.nerdfonts.override { fonts = [ "NerdFontsSymbolsOnly" ]; };
      };

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
            "SF Pro Rounded"
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
  };
}
