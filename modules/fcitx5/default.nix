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
  ja = "ja_JP.UTF-8";
  extraLocaleSettings = {
    LC_ADDRESS = ja;
    LC_IDENTIFICATION = ja;
    LC_MEASUREMENT = ja;
    LC_MONETARY = ja;
    LC_MESSAGES = en;
    LC_NAME = ja;
    LC_NUMERIC = ja;
    LC_PAPER = ja;
    LC_TELEPHONE = ja;
    LC_TIME = ja;
  };

  cfg = config.myOptions.fcitx5;
in
{
  options.myOptions.fcitx5 = {
    enable = mkEnableOption "fcitx5 service" // {
      default = config.vars.withGui;
    };
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
            inputs.self.packages.${pkgs.stdenv.hostPlatform.system}.catppuccin-fcitx5 # Theme
            libsForQt5.fcitx5-qt
          ];
        };
      };
    };

    systemd.user.tmpfiles.users.${config.vars.username}.rules = [
      "L+ %h/.config/fcitx5 0755 ${config.vars.username} users - ${./config}"
    ];
  };
}
