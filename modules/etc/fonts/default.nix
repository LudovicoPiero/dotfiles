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

  cfg = config.mine.fonts;
in
{
  options.mine.fonts = {
    enable = mkEnableOption "Fonts";

    main = {
      name = mkOption {
        type = types.str;
        default = "SF Pro";
      };
      package = mkOption {
        type = types.package;
        default = inputs.ludovico-pkgs.packages.${pkgs.stdenv.hostPlatform.system}.san-francisco-pro;
      };
    };

    terminal = {
      name = mkOption {
        type = types.str;
        default = "Iosevka Q";
      };
      package = mkOption {
        type = types.package;
        default = inputs.ludovico-pkgs.packages.${pkgs.stdenv.hostPlatform.system}.iosevka-q;
      };
    };

    cjk = {
      name = mkOption {
        type = types.str;
        default = "Noto Sans CJK";
      };
      package = mkOption {
        type = types.package;
        default = pkgs.noto-fonts-cjk-sans;
      };
    };

    emoji = {
      name = mkOption {
        type = types.str;
        default = "Noto Color Emoji";
      };
      package = mkOption {
        type = types.package;
        default = pkgs.noto-fonts-color-emoji;
      };
    };

    icon = {
      name = mkOption {
        type = types.str;
        default = "Symbols Nerd Font Mono";
      };
      package = mkOption {
        type = types.package;
        default = pkgs.nerd-fonts.symbols-only;
      };
    };

    size = mkOption {
      type = types.int;
      default = 14;
    };
  };

  config = mkIf cfg.enable {
    environment.sessionVariables = {
      FREETYPE_PROPERTIES = "cff:no-stem-darkening=0 autofitter:no-stem-darkening=0 cff:hinting-engine=adobe";
    };

    fonts = {
      fontDir.enable = true;
      packages = [
        cfg.main.package
        cfg.terminal.package
        cfg.cjk.package
        cfg.emoji.package
        cfg.icon.package

        pkgs.symbola
        pkgs.wqy_zenhei # For Steam
      ];

      # use fonts specified by user rather than default ones
      enableDefaultPackages = false;
      fontconfig = {
        enable = true;
        cache32Bit = true;
        defaultFonts = {
          serif = [
            "${cfg.main.name}"
            "${cfg.cjk.name}"
            "${cfg.emoji.name}"
            "${cfg.icon.name}"
            "Symbola"
          ];

          sansSerif = [
            "${cfg.main.name}"
            "${cfg.cjk.name}"
            "${cfg.emoji.name}"
            "${cfg.icon.name}"
            "Symbola"
          ];

          monospace = [
            "${cfg.main.name}"
            "${cfg.cjk.name}"
            "${cfg.emoji.name}"
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
