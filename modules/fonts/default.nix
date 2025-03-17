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

    main = mkOption {
      type = types.submodule {
        options = {
          name = mkOption {
            type = types.str;
            default = "Iosevka q";
          };
          package = mkOption {
            type = types.package;
            default = inputs.self.packages.${pkgs.stdenv.hostPlatform.system}.iosevka-q;
          };
        };
      };
      default = { };
    };

    #TODO: PLS HELP!!!
    # cjk = {
    #   name = mkOption {
    #     type = types.listOf types.str;
    #     default = [
    #       "Sarasa Gothic J"
    #       "Sarasa Gothic K"
    #       "Sarasa Gothic SC"
    #       "Sarasa Gothic TC"
    #       "Sarasa Gothic HC"
    #       "Sarasa Gothic CL"
    #     ];
    #   };
    #
    #   package = mkOption {
    #     type = types.package;
    #     default = inputs.self.packages.${pkgs.stdenv.hostPlatform.system}.sarasa-gothic;
    #   };
    # };

    size = mkOption {
      type = types.int;
      default = 12;
    };
  };

  config = mkIf cfg.enable {
    fonts = {
      fontDir.enable = true;
      packages = [
        cfg.main.package
        # cfg.cjk.package

        inputs.self.packages.${pkgs.stdenv.hostPlatform.system}.sarasa-gothic

        pkgs.emacs-all-the-icons-fonts
        pkgs.material-design-icons
        pkgs.noto-fonts-emoji
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
            "${cfg.main.name}"
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
            "${cfg.main.name}"
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
