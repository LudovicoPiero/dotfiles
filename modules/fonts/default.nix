{
  lib,
  pkgs,
  config,
  inputs,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    mkOption
    mkIf
    types
    ;

  cfg = config.myOptions.fonts;
in
{
  options.myOptions.fonts = {
    enable = mkEnableOption "Fonts" // {
      default = config.vars.withGui;
    };

    main = {
      name = mkOption {
        type = types.str;
        default = "Iosevka SS14";
      };
      package = mkOption {
        type = types.package;
        default = pkgs.iosevka-bin.override { variant = "SS14"; };
      };
    };

    cjk = {
      name = mkOption {
        type = types.str;
        default = "Noto Serif CJK";
      };
      package = mkOption {
        type = types.package;
        default = pkgs.noto-fonts-cjk-serif;
      };
    };

    emoji = {
      name = mkOption {
        type = types.str;
        default = "Noto Color Emoji";
      };
      package = mkOption {
        type = types.package;
        default = pkgs.noto-fonts-emoji;
      };
    };

    icon = {
      name = mkOption {
        type = types.str;
        default = "Material Design Icons";
      };
      package = mkOption {
        type = types.package;
        default = pkgs.material-design-icons;
      };
    };

    size = mkOption {
      type = types.int;
      default = 14;
    };
  };

  config = mkIf cfg.enable {
    fonts = {
      fontDir.enable = true;
      packages = [
        cfg.main.package
        cfg.cjk.package
        cfg.emoji.package
        cfg.icon.package

        inputs.self.packages.${pkgs.stdenv.hostPlatform.system}.sarasa-gothic

        pkgs.symbola
        pkgs.wqy_zenhei # For Steam
      ];

      # use fonts specified by user rather than default ones
      enableDefaultPackages = false;
      fontconfig = {
        enable = true;
        defaultFonts = {
          serif = [
            "${cfg.main.name}"
            "${cfg.cjk.name}"
            "${cfg.icon.name}"
            "Symbola"
          ];

          sansSerif = [
            "${cfg.main.name}"
            "${cfg.cjk.name}"
            "${cfg.icon.name}"
            "Symbola"
          ];

          monospace = [
            "${cfg.main.name}"
            "${cfg.cjk.name}"
            "${cfg.icon.name}"
            "Symbola"
          ];

          emoji = [
            "${cfg.emoji.name}"
            "${cfg.icon.name}"
            "Symbola"
          ];
        };
      };
    };
  };
}
