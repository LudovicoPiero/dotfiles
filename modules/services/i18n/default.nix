{
  lib,
  config,
  pkgs,
  self',
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.inputMethod;
  localeCfg = config.mine.inputMethod.locale;

  gnome = config.mine.gnome.enable;
  kde = config.mine.kde.enable;

  selectedInputMethod =
    let
      autoPick =
        if kde then
          lib.warnIf (
            cfg.type == null
          ) "mine.inputMethod: KDE detected → automatically selecting 'fcitx5'." "fcitx5"
        else if gnome then
          lib.warnIf (
            cfg.type == null
          ) "mine.inputMethod: GNOME detected → automatically selecting 'ibus'." "ibus"
        else
          "fcitx5";
    in
    if cfg.type != null then cfg.type else autoPick;
in
{
  options.mine.inputMethod = {
    enable = mkEnableOption "Enable input-method management";

    locale = {
      defaultLocale = lib.mkOption {
        type = lib.types.str;
        default = "ja_JP.UTF-8";
        description = "Default system locale for input method support";
      };
      extraLocales = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [
          "ja_JP.UTF-8/UTF-8"
          "en_US.UTF-8/UTF-8"
        ];
        description = "Additional locales to generate for input methods";
      };
    };

    type = lib.mkOption {
      type = lib.types.enum [
        "fcitx5"
        "ibus"
      ];
      default = null;
      description = "Force-select the input method (fcitx5 or ibus).";
    };
  };

  config = mkIf cfg.enable {
    i18n = {
      inherit (localeCfg) extraLocales defaultLocale;

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
            fcitx5-mozc-ut
            fcitx5-hangul
            fcitx5-gtk
            libsForQt5.fcitx5-qt
            self'.packages.catppuccin-fcitx5
          ];
        };
      };
    };

    systemd.user.units."app-org.fcitx.Fcitx5@autostart.service".enable = mkIf (
      selectedInputMethod == "fcitx5"
    ) false;

    systemd.user.tmpfiles.users.${config.vars.username}.rules = mkIf (
      selectedInputMethod == "fcitx5"
    ) [ "L+ %h/.config/fcitx5 0755 ${config.vars.username} users - ${./config}" ];
  };
}
