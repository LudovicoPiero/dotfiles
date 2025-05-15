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
    ;

  jsonFormat = pkgs.formats.json { };

  cfg = config.myOptions.moonlight;
in
{
  options.myOptions.moonlight = {
    enable = mkEnableOption "Moonlight - Yet another Discord mod";

    package = mkOption {
      type = types.package;
      default =
        inputs.moonlight.packages.${pkgs.stdenv.hostPlatform.system}."discord-${cfg.discordVariants}";
    };

    discordVariants = mkOption {
      type = types.str;
      default = "stable";
    };

    settings = mkOption {
      type = jsonFormat.type;
      default = { };
      description = ''
        Config files written to
        `$XDG_CONFIG_HOME/moonlight-mod/${cfg.discordVariants}.json`.
      '';
      example = lib.literalExpression ''
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
