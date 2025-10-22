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
  localeCfg = cfg.locale;
in
{
  options.mine = {
    fcitx5 = {
      enable = mkEnableOption "fcitx5 service";

      locale = {
        defaultLocale = lib.mkOption {
          type = lib.types.str;
          default = "ja_JP.UTF-8";
          description = "Default system locale";
        };
        extraLocales = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [
            "ja_JP.UTF-8"
            "en_US.UTF-8/UTF-8"
          ];
          description = "List of additional locales to generate";
        };
      };
    };
  };

  config = mkIf cfg.enable {
    hm = {
      home.language.base = localeCfg.defaultLocale;
    };

    i18n = {
      # Locale Settings
      inherit (localeCfg) defaultLocale;
      inherit (localeCfg) extraLocales;
      extraLocaleSettings = {
        LANGUAGE = "ja_JP.UTF-8";
        LC_ALL = "ja_JP.UTF-8";
        LC_CTYPE = "ja_JP.UTF-8";
        LC_ADDRESS = "ja_JP.UTF-8";
        LC_IDENTIFICATION = "ja_JP.UTF-8";
        LC_MEASUREMENT = "ja_JP.UTF-8";
        LC_MESSAGES = "ja_JP.UTF-8";
        LC_MONETARY = "ja_JP.UTF-8";
        LC_NAME = "ja_JP.UTF-8";
        LC_NUMERIC = "ja_JP.UTF-8";
        LC_PAPER = "ja_JP.UTF-8";
        LC_TELEPHONE = "ja_JP.UTF-8";
        LC_TIME = "ja_JP.UTF-8";
        LC_COLLATE = "ja_JP.UTF-8";
      };

      # The Real FCITX5 Settings
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
            (libsForQt5.fcitx5-qt.overrideAttrs (old: {
              patches = old.patches or [ ] ++ [
                (pkgs.fetchpatch2 {
                  url = "https://github.com/fcitx/fcitx5-qt/commit/46a07a85d191fd77a1efc39c8ed43d0cd87788d2.patch?full_index=1";
                  hash = "sha256-qv8Rj6YoFdMQLOB2R9LGgwCHKdhEji0Sg67W37jSIac=";
                })
                (pkgs.fetchpatch2 {
                  url = "https://github.com/fcitx/fcitx5-qt/commit/6ac4fdd8e90ff9c25a5219e15e83740fa38c9c71.patch?full_index=1";
                  hash = "sha256-x0OdlIVmwVuq2TfBlgmfwaQszXLxwRFVf+gEU224uVA=";
                })
                (pkgs.fetchpatch2 {
                  url = "https://github.com/fcitx/fcitx5-qt/commit/1d07f7e8d6a7ae8651eda658f87ab0c9df08bef4.patch?full_index=1";
                  hash = "sha256-22tKD7sbsTJcNqur9/Uf+XAvMvA7tzNQ9hUCMm+E+E0=";
                })
              ];
            }))

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
