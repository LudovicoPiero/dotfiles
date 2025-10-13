{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;

  # en = "en_US.UTF-8";
  ja = "ja_JP.UTF-8";
  defaultLocale = ja;
  extraLocales = [
    "ja_JP.UTF-8/UTF-8"
    "en_US.UTF-8/UTF-8"
  ];
  extraLocaleSettings = {
    LC_ALL = ja;
    LC_ADDRESS = ja;
    LC_IDENTIFICATION = ja;
    LC_MEASUREMENT = ja;
    LC_MONETARY = ja;
    LC_MESSAGES = ja;
    LC_NAME = ja;
    LC_NUMERIC = ja;
    LC_PAPER = ja;
    LC_TELEPHONE = ja;
    LC_TIME = ja;
  };

  cfg = config.mine.fcitx5;
in
{
  options.mine.fcitx5 = {
    enable = mkEnableOption "fcitx5 service";
  };

  config = mkIf cfg.enable {
    hm = {
      home.language = {
        address = ja;
        base = ja;
        collate = ja;
        ctype = ja;
        measurement = ja;
        messages = ja;
        monetary = ja;
        name = ja;
        numeric = ja;
        paper = ja;
        telephone = ja;
        time = ja;
      };
    };

    environment.variables = {
      LANG = ja;
      LC_ALL = ja;
    };

    i18n = {
      inherit defaultLocale extraLocaleSettings extraLocales;
      inputMethod = {
        enable = true;
        type = "fcitx5";
        fcitx5 = {
          waylandFrontend = true;
          addons = with pkgs; [
            # Languages
            fcitx5-mozc # Japanese
            fcitx5-hangul # Korean

            # Input methods Module
            fcitx5-gtk
            libsForQt5.fcitx5-qt

            # Theme
            inputs.ludovico-pkgs.packages.${pkgs.stdenv.hostPlatform.system}.catppuccin-fcitx5
          ];
        };
      };
    };

    hm = {
      systemd.user.services.fcitx5 = {
        Unit = {
          Description = "Input method framework";
          BindsTo = [ "graphical-session.target" ];
          After = [ "graphical-session.target" ];
        };
        Install = {
          WantedBy = [ "graphical-session.target" ];
        };
        Service = {
          Type = "simple";
          Restart = "on-failure";
          ExecStart = "${lib.getExe pkgs.fcitx5}";
        };
      };
    };

    systemd.user.tmpfiles.users.${config.vars.username}.rules = [
      "L+ %h/.config/fcitx5 0755 ${config.vars.username} users - ${./config}"
    ];
  };
}
