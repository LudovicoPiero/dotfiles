{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;

  en = "en_US.UTF-8";
  # ja = "ja_JP.UTF-8";
  extraLocaleSettings = {
    LC_ADDRESS = en;
    LC_IDENTIFICATION = en;
    LC_MEASUREMENT = en;
    LC_MONETARY = en;
    LC_MESSAGES = en;
    LC_NAME = en;
    LC_NUMERIC = en;
    LC_PAPER = en;
    LC_TELEPHONE = en;
    LC_TIME = en;
  };

  cfg = config.myOptions.fcitx5;
in
{
  options.myOptions.fcitx5 = {
    enable = mkEnableOption "fcitx5 service";
  };

  config = mkIf cfg.enable {
    i18n = {
      inherit extraLocaleSettings;
      inputMethod = {
        enable = true;
        type = "fcitx5";
        fcitx5 = {
          waylandFrontend = true;
          addons = with pkgs; [
            fcitx5-mozc
            fcitx5-gtk
            inputs.ludovico-pkgs.packages.${pkgs.stdenv.hostPlatform.system}.catppuccin-fcitx5 # Theme
            libsForQt5.fcitx5-qt
          ];
        };
      };
    };

    systemd.user.services.fcitx5 = {
      enable = true;
      description = "Input method framework";
      after = [ "graphical-session.target" ];
      wantedBy = [ "graphical-session.target" ];
      bindsTo = [ "graphical-session.target" ];
      serviceConfig = {
        Type = "simple";
        Restart = "on-failure";
        ExecStart = "${lib.getExe pkgs.fcitx5}";
      };
    };

    systemd.user.tmpfiles.users.${config.vars.username}.rules = [
      "L+ %h/.config/fcitx5 0755 ${config.vars.username} users - ${./config}"
    ];
  };
}
