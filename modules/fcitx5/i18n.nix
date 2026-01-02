{
  lib,
  config,
  pkgs,
  ...
}:

let
  inherit (lib)
    mkEnableOption
    mkIf
    mkOption
    types
    ;
  cfg = config.mine.inputMethod;

  fontName = config.mine.fonts.terminal.name;
  fontSize = toString config.mine.fonts.size;

  selectedInputMethod = if cfg.type != null then cfg.type else "fcitx5";
in
{
  options.mine.inputMethod = {
    enable = mkEnableOption "Enable input-method management";

    type = mkOption {
      type = types.nullOr (
        types.enum [
          "fcitx5"
          "ibus"
        ]
      );
      default = null;
      description = "Force-select the input method. Defaults to fcitx5.";
    };
  };

  config = mkIf cfg.enable {
    i18n = {
      defaultLocale = "en_US.UTF-8";
      supportedLocales = [
        "en_US.UTF-8/UTF-8"
        "ja_JP.UTF-8/UTF-8"
        "ko_KR.UTF-8/UTF-8"
      ];

      inputMethod = {
        enable = true;
        type = selectedInputMethod;

        fcitx5 = mkIf (selectedInputMethod == "fcitx5") {
          waylandFrontend = true;
          addons = with pkgs; [
            fcitx5-mozc
            fcitx5-hangul
            fcitx5-gtk
            libsForQt5.fcitx5-qt
            fcitx5-tokyonight
          ];
        };
      };
    };

    environment.sessionVariables = mkIf (selectedInputMethod == "fcitx5") {
      XMODIFIERS = "@im=fcitx";
      QT_IM_MODULE = "fcitx";
    };

    hj.xdg.config.files = mkIf (selectedInputMethod == "fcitx5") {
      "fcitx5/conf/classicui.conf".text = ''
        Vertical Candidate List=False
        PerScreenDPI=True
        WheelForPaging=True
        Font="${fontName} ${fontSize}"
        MenuFont="${fontName} ${fontSize}"
        TrayFont="${fontName} ${fontSize}"
        TrayOutlineColor=#000000
        TrayTextColor=#ffffff
        PreferTextIcon=True
        ShowLayoutNameInIcon=True
        UseInputMethodLangaugeToDisplayText=True
        Theme=Tokyonight-Storm
      '';

      "fcitx5/config".text = ''
        [Hotkey]
        EnumerateWithTriggerKeys=True
        EnumerateSkipFirst=False

        [Hotkey/TriggerKeys]
        0=Control+Shift+space

        [Hotkey/EnumerateForwardKeys]
        0=Control+Shift_L

        [Hotkey/EnumerateBackwardKeys]
        0=Control+Shift_R

        [Behavior]
        ActiveByDefault=False

        ShareInputState=No
        PreeditEnabledByDefault=True
        ShowInputMethodInformation=True
        CompactInputMethodInformation=True
        ShowFirstInputMethodInformation=True
        DefaultPageSize=5
      '';

      "fcitx5/profile".text = ''
        [Groups/0]
        Name=Default
        Default Layout=us
        DefaultIM=keyboard-us

        [Groups/0/Items/0]
        Name=keyboard-us
        Layout=

        [Groups/0/Items/1]
        Name=mozc
        Layout=

        [Groups/0/Items/2]
        Name=hangul
        Layout=

        [GroupOrder]
        0=Default
      '';
    };
  };
}
