{
  config,
  lib,
  pkgs,
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
    enable = mkEnableOption "Fonts configuration";

    main = {
      name = mkOption {
        type = types.str;
        default = "Inter";
      };
      package = mkOption {
        type = types.package;
        default = pkgs.inter;
      };
    };

    terminal = {
      name = mkOption {
        type = types.str;
        default = "JetBrains Mono";
      };
      package = mkOption {
        type = types.package;
        default = pkgs.jetbrains-mono;
      };
    };

    cjk = {
      name = mkOption {
        type = types.str;
        default = "Noto Sans CJK JP";
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
        default = "Symbols Nerd Font";
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
    nixpkgs.overlays = [
      (final: prev: {
        iosevka-q = final.callPackage ../../packages/iosevka-q { };

        #TODO: REMOVE LATER!!
        openblas =
          if prev.stdenv.hostPlatform.system == "i686-linux" then
            prev.openblas.overrideAttrs (_: {
              doCheck = false;
            })
          else
            prev.openblas;
      })
    ];

    environment.sessionVariables = {
      # Improved font rendering settings
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
        pkgs.wqy_zenhei # Fallback for Steam/Games
      ];

      # Force applications to use our configured defaults
      enableDefaultPackages = false;

      fontconfig = {
        enable = true;
        cache32Bit = true;

        defaultFonts = {
          serif = [
            cfg.main.name
            cfg.cjk.name
            cfg.emoji.name
            cfg.icon.name
            "Symbola"
          ];
          sansSerif = [
            cfg.main.name
            cfg.cjk.name
            cfg.emoji.name
            cfg.icon.name
            "Symbola"
          ];
          monospace = [
            cfg.terminal.name
            cfg.cjk.name
            cfg.emoji.name
            cfg.icon.name
            "Symbola"
          ];
          emoji = [
            cfg.emoji.name
            cfg.icon.name
            "Symbola"
          ];
        };
      };
    };
  };
}
