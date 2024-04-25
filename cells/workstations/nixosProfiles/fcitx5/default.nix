{ pkgs, ... }:
let
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
in
{
  i18n = {
    inherit extraLocaleSettings;
    inputMethod = {
      enabled = "fcitx5"; # Uncomment to enable this
      fcitx5 = {
        waylandFrontend = true;
        addons = with pkgs; [
          fcitx5-mozc
          fcitx5-gtk
          libsForQt5.fcitx5-qt
        ];
      };
    };
  };

  systemd.user.tmpfiles.users.airi.rules = [ "L+ %h/.config/fcitx5 0755 airi users - ${./__config}" ];
}
