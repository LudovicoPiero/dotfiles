{
  lib,
  config,
  pkgs,
  self',
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.mine.fcitx5;
  localeCfg = cfg.locale;

  gnome = config.mine.gnome.enable;
  kde = config.mine.kde.enable;

  # Automatically pick the input method
  selectedInputMethod =
    if kde then
      "fcitx5"
    else if gnome then
      "ibus"
    else
      cfg.inputMethod or "fcitx5"; # fallback
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
            "ja_JP.UTF-8/UTF-8"
            "en_US.UTF-8/UTF-8"
          ];
          description = "List of additional locales to generate";
        };
      };

      # Optional fallback so user can override
      inputMethod = lib.mkOption {
        type = lib.types.enum [
          "fcitx5"
          "ibus"
        ];
        default = null;
        description = "Override auto-selected input method (fcitx5/ibus).";
      };
    };
  };

  config = mkIf cfg.enable {
    ###########
    #  LOCALE #
    ###########
    i18n = {
      inherit (localeCfg) defaultLocale;
      inherit (localeCfg) extraLocales;

      extraLocaleSettings = {
        LANGUAGE = "en_US.UTF-8";
        LC_ALL = "en_US.UTF-8";
        LC_CTYPE = "en_US.UTF-8";
        LC_ADDRESS = "en_US.UTF-8";
        LC_IDENTIFICATION = "en_US.UTF-8";
        LC_MEASUREMENT = "en_US.UTF-8";
        LC_MESSAGES = "en_US.UTF-8";
        LC_MONETARY = "en_US.UTF-8";
        LC_NAME = "en_US.UTF-8";
        LC_NUMERIC = "en_US.UTF-8";
        LC_PAPER = "en_US.UTF-8";
        LC_TELEPHONE = "en_US.UTF-8";
        LC_TIME = "en_US.UTF-8";
        LC_COLLATE = "en_US.UTF-8";
      };

      #########################
      # INPUT METHOD SELECTOR #
      #########################
      inputMethod = {
        enable = true;
        type = selectedInputMethod;

        ibus = mkIf (selectedInputMethod == "ibus") {
          engines = with pkgs.ibus-engines; [
            mozc-ut
            hangul
          ];
        };

        fcitx5 = mkIf (selectedInputMethod == "fcitx5") {
          waylandFrontend = true;
          addons = with pkgs; [
            fcitx5-mozc
            fcitx5-hangul
            fcitx5-gtk
            libsForQt5.fcitx5-qt
            self'.packages.catppuccin-fcitx5
          ];
        };
      };
    };

    # Only apply when using fcitx5 (KDE or manual override)
    systemd.user.units."app-org.fcitx.Fcitx5@autostart.service".enable = mkIf (
      selectedInputMethod == "fcitx5"
    ) false;

    ###############################
    # fcitx5 custom config folder #
    ###############################
    systemd.user.tmpfiles.users.${config.vars.username}.rules = mkIf (
      selectedInputMethod == "fcitx5"
    ) [ "L+ %h/.config/fcitx5 0755 ${config.vars.username} users - ${./config}" ];
  };
}
