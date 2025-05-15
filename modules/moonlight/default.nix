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
    mkIf
    mkOption
    types
    literalExpression
    ;

  jsonFormat = pkgs.formats.json { };

  moonlightPackages =
    inputs.moonlight.packages.${pkgs.stdenv.hostPlatform.system}."discord-${cfg.discordVariants}";

  discordVariantsOption = mkOption {
    type = types.str;
    default = "stable";
    description = "Which Discord variant to use (e.g., 'stable', 'ptb', 'canary', or 'development').";
  };

  cfg = config.myOptions.moonlight;
in
{
  options.myOptions.moonlight = {
    enable = mkEnableOption "Moonlight - Yet another Discord mod";

    discordVariants = discordVariantsOption;

    package = mkOption {
      type = types.package;
      default = moonlightPackages;
      description = "The Moonlight-wrapped Discord package to use.";
    };

    settings = mkOption {
      type = jsonFormat.type;
      default = { };
      description = ''
        Config written to
        `$XDG_CONFIG_HOME/moonlight-mod/${cfg.discordVariants}.json`.
      '';
      example = literalExpression ''
        {
          extensions = {
            moonbase = true;
            disableSentry = true;
            noTrack = true;
            noHideToken = true;
          };
          repositories = [
            "https://moonlight-mod.github.io/extensions-dist/repo.json"
          ];
        }
      '';
    };
  };

  config = mkIf cfg.enable {
    hj = {
      packages = [ cfg.package ];

      files = {
        ".config/moonlight-mod/${cfg.discordVariants}.json" = {
          source = jsonFormat.generate "Moonlight settings" cfg.settings;
        };
      };
    };
  };
}
