{
  lib,
  pkgs,
  config,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    mkIf
    mkPackageOption
    mkOption
    types
    ;

  extraOptionsStr = lib.escapeShellArgs cfg.extraOptions;

  cfg = config.myOptions.cliphist;
in
{
  options.myOptions.cliphist = {
    enable = mkEnableOption "cliphist service" // {
      default = config.myOptions.hyprland.enable;
    };

    package = mkPackageOption pkgs "cliphist" { };

    allowImages = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Store images in clipboard history.
      '';
    };

    extraOptions = mkOption {
      type = with types; listOf str;
      default = [
        "-max-dedupe-search"
        "10"
        "-max-items"
        "500"
      ];
      description = ''
        Flags to append to the cliphist command.
      '';
    };

    systemdTargets = mkOption {
      type = with types; either (listOf str) str;
      default = [ "graphical-session.target" ];
      example = "sway-session.target";
      description = ''
        The systemd targets that will automatically start the cliphist service.

        When setting this value to `["sway-session.target"]`,
        make sure to also enable {option}`wayland.windowManager.sway.systemd.enable`,
        otherwise the service may never be started.

        Note: A single string value is deprecated, please use a list.
      '';
    };
  };

  config = mkIf cfg.enable {
    hj.packages = [ cfg.package ];

    systemd.user.services.cliphist = {
      description = "Clipboard management daemon";
      partOf = lib.toList cfg.systemdTargets;
      after = lib.toList cfg.systemdTargets;
      wantedBy = lib.toList cfg.systemdTargets;

      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.wl-clipboard}/bin/wl-paste --watch ${cfg.package}/bin/cliphist ${extraOptionsStr} store";
        Restart = "on-failure";
      };

    };

    systemd.user.services.cliphist-images = lib.mkIf cfg.allowImages {
      description = "Clipboard management daemon - images";
      partOf = lib.toList cfg.systemdTargets;
      after = lib.toList cfg.systemdTargets;
      wantedBy = lib.toList cfg.systemdTargets;

      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.wl-clipboard}/bin/wl-paste --type image --watch ${cfg.package}/bin/cliphist ${extraOptionsStr} store";
        Restart = "on-failure";
      };

    };
  };
}
