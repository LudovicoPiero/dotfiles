{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.mine.fcitx5;
in
{
  options.mine.fcitx5 = {
    enable = mkEnableOption "fcitx5 service";
  };

  config = mkIf cfg.enable {
    hm = {
      home.language = {
        address = "ja_JP.UTF-8";
        base = "ja_JP.UTF-8";
        collate = "ja_JP.UTF-8";
        ctype = "ja_JP.UTF-8";
        measurement = "ja_JP.UTF-8";
        messages = "ja_JP.UTF-8";
        monetary = "ja_JP.UTF-8";
        name = "ja_JP.UTF-8";
        numeric = "ja_JP.UTF-8";
        paper = "ja_JP.UTF-8";
        telephone = "ja_JP.UTF-8";
        time = "ja_JP.UTF-8";
      };
    };

    environment.variables = {
      LANG = "ja_JP.UTF-8";
      LC_ALL = "ja_JP.UTF-8";
    };

    i18n = {
      defaultLocale = "ja_JP.UTF-8";
      extraLocales = [
        "ja_JP.UTF-8/UTF-8"
        "en_US.UTF-8/UTF-8"
      ];
      extraLocaleSettings.LC_ALL = "ja_JP.UTF-8";
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
