{pkgs, ...}: let
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
in {
  time.timeZone = "Asia/Tokyo";

  i18n = {
    inherit extraLocaleSettings;
    defaultLocale = en;
    supportedLocales = [
      "en_US.UTF-8/UTF-8"
      "ja_JP.UTF-8/UTF-8"
    ];
    inputMethod = {
      # enabled = "fcitx5"; # Uncomment to enable this
      fcitx5.addons = with pkgs; [
        fcitx5-mozc
        fcitx5-gtk
        libsForQt5.fcitx5-qt
      ];
    };
  };

  systemd.user.tmpfiles.users.ludovico.rules = ["L+ %h/.config/fcitx5 0755 ludovico users - ${./fcitx5}"];
}
