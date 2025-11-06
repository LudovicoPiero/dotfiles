{
  lib,
  config,
  pkgs,
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
            "ja_JP.UTF-8/UTF-8"
            "en_US.UTF-8/UTF-8"
          ];
          description = "List of additional locales to generate";
        };
      };
    };
  };

  config = mkIf cfg.enable {
    i18n = {
      # Locale Settings
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

      # The Real FCITX5 Settings
      inputMethod = {
        enable = true;

        # Ibus
        type = "ibus";
        ibus.engines = with pkgs.ibus-engines; [
          mozc-ut # Japanese
          hangul # Korean
        ];

        # FCITX5
        # type = "fcitx5";
        # fcitx5 = {
        #   waylandFrontend = true;
        #   addons = with pkgs; [
        #     # Languages
        #     fcitx5-mozc # Japanese
        #     fcitx5-hangul # Korean
        #
        #     # Input methods Module
        #     fcitx5-gtk
        #     libsForQt5.fcitx5-qt
        #
        #     # Theme
        #     inputs'.ludovico-pkgs.packages.catppuccin-fcitx5
        #   ];
        # };
      };
    };

    # systemd.user.tmpfiles.users.${config.vars.username}.rules = [
    #   "L+ %h/.config/fcitx5 0755 ${config.vars.username} users - ${./config}"
    # ];
  };
}
