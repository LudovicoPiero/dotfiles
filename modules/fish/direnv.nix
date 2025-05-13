{
  pkgs,
  lib,
  config,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    mkPackageOption
    mkIf
    mkOption
    getExe
    ;

  tomlFormat = pkgs.formats.toml { };

  cfg = config.myOptions.direnv;
in
{
  options.myOptions.direnv = {
    enable = mkEnableOption "Direnv" // {
      default = true;
    };

    package = mkPackageOption pkgs "direnv" { };

    config = mkOption {
      type = tomlFormat.type;
      default = { };
      description = ''
        Configuration written to
        {file}`$XDG_CONFIG_HOME/direnv/direnv.toml`.

        See
        {manpage}`direnv.toml(1)`.
        for the full list of options.
      '';
    };

    nix-direnv = {
      enable =
        mkEnableOption ''
          [nix-direnv](https://github.com/nix-community/nix-direnv),
          a fast, persistent use_nix implementation for direnv
        ''
        // {
          default = true;
        };

      package = mkPackageOption pkgs "nix-direnv" { };
    };

    silent = mkEnableOption "silent mode, that is, disabling direnv logging" // {
      default = true;
    };
  };

  config = mkIf cfg.enable {
    hj = {
      packages = [ cfg.package ];

      files = {
        ".config/direnv/lib/hjem-nix-direnv.sh" = mkIf cfg.nix-direnv.enable {
          source = "${cfg.nix-direnv.package}/share/nix-direnv/direnvrc";
        };

        ".config/direnv/direnv.toml" = mkIf (cfg.config != { } || cfg.silent) {
          source = tomlFormat.generate "direnv-config" (
            cfg.config
            // lib.optionalAttrs cfg.silent {
              global = {
                log_format = "-";
                log_filter = "^$";
              };
            }
          );
        };
      };

      rum.programs.fish.earlyConfigFiles.direnv = ''
        ${getExe cfg.package} hook fish | source
      '';

      environment.sessionVariables = mkIf cfg.silent { DIRENV_LOG_FORMAT = ""; };
    };
  };
}
